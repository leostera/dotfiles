local namespace = vim.api.nvim_create_namespace("branch_diff_signs")
local generations = {}

local function git(root, args)
  local command = { "git", "-C", root }
  vim.list_extend(command, args)
  local output = vim.fn.system(command)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return output
end

local function merge_base(root)
  local bases = {}
  local remote_head = git(root, {
    "symbolic-ref", "--quiet", "--short", "refs/remotes/origin/HEAD",
  })
  if remote_head then
    table.insert(bases, vim.trim(remote_head))
  end
  vim.list_extend(bases, {
    "main", "origin/main", "master", "origin/master", "trunk", "origin/trunk",
  })

  for _, base in ipairs(bases) do
    local result = git(root, { "merge-base", base, "HEAD" })
    if result then
      return vim.trim(result)
    end
  end
end

local function parse_hunks(diff)
  local hunks = {}
  for line in diff:gmatch("[^\r\n]+") do
    local old_start, old_count, new_start, new_count = line:match(
      "^@@ %-(%d+),?(%d*) %+(%d+),?(%d*) @@"
    )
    if old_start then
      table.insert(hunks, {
        old_start = tonumber(old_start),
        old_count = old_count == "" and 1 or tonumber(old_count),
        new_start = tonumber(new_start),
        new_count = new_count == "" and 1 or tonumber(new_count),
      })
    end
  end
  return hunks
end

-- Translate a line in HEAD to the current file, omitting lines touched since HEAD.
local function current_line(head_line, working_hunks)
  local offset = 0
  for _, hunk in ipairs(working_hunks) do
    local old_end = hunk.old_start + hunk.old_count - 1
    if hunk.old_count > 0 and head_line >= hunk.old_start and head_line <= old_end then
      return nil
    end

    local before_line
    if hunk.old_count == 0 then
      before_line = hunk.old_start < head_line
    else
      before_line = old_end < head_line
    end
    if before_line then
      offset = offset + hunk.new_count - hunk.old_count
    end
  end
  return head_line + offset
end

local function clear(bufnr)
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  end
end

local function update(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  clear(bufnr)

  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" or vim.bo[bufnr].buftype ~= "" then
    return
  end

  -- Unsaved buffer edits cannot be mapped safely to HEAD; keep GitGutter's
  -- regular signs and wait until the buffer is written before adding branch signs.
  if vim.bo[bufnr].modified then
    return
  end

  local absolute = vim.fn.fnamemodify(filename, ":p")
  local directory = vim.fn.fnamemodify(absolute, ":h")
  local root_output = vim.fn.system({ "git", "-C", directory, "rev-parse", "--show-toplevel" })
  if vim.v.shell_error ~= 0 then
    return
  end
  local root = vim.trim(root_output)
  local relative = vim.fs.relpath(root, absolute)
  if not relative then
    return
  end

  local base = merge_base(root)
  if not base then
    return
  end

  local branch_diff = git(root, {
    "diff", "--no-ext-diff", "--unified=0", base, "HEAD", "--", ":(literal)" .. relative,
  })
  local working_diff = git(root, {
    "diff", "--no-ext-diff", "--unified=0", "HEAD", "--", ":(literal)" .. relative,
  })
  if not branch_diff or not working_diff then
    return
  end

  local branch_hunks = parse_hunks(branch_diff)
  local working_hunks = parse_hunks(working_diff)
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  for _, hunk in ipairs(branch_hunks) do
    if hunk.new_count > 0 then
      for line = hunk.new_start, hunk.new_start + hunk.new_count - 1 do
        local mapped = current_line(line, working_hunks)
        if mapped and mapped >= 1 and mapped <= line_count then
          vim.api.nvim_buf_set_extmark(bufnr, namespace, mapped - 1, 0, {
            sign_text = "⎇",
            sign_hl_group = "Comment",
            priority = 5,
          })
        end
      end
    else
      local anchor = math.max(hunk.new_start, 1)
      local mapped = current_line(anchor, working_hunks)
      if mapped and mapped >= 1 and mapped <= line_count then
        vim.api.nvim_buf_set_extmark(bufnr, namespace, mapped - 1, 0, {
          sign_text = "⎇",
          sign_hl_group = "Comment",
          priority = 5,
        })
      end
    end
  end
end

local function schedule(bufnr)
  generations[bufnr] = (generations[bufnr] or 0) + 1
  local generation = generations[bufnr]
  vim.defer_fn(function()
    if generations[bufnr] == generation then
      update(bufnr)
    end
  end, 100)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
  group = vim.api.nvim_create_augroup("BranchDiffSigns", { clear = true }),
  callback = function(args)
    schedule(args.buf)
  end,
})
