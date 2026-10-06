local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- LSP keymaps (defined globally, will work when LSP attaches)
keymap("n", "<leader>e", vim.diagnostic.open_float, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>q", vim.diagnostic.setloclist, opts)
keymap("n", "<space>do", vim.diagnostic.open_float, opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Comments (vim-commentary)
keymap("n", "<leader><leader>c", "gcc", { noremap = false })
keymap("v", "<leader><leader>c", "gc", { noremap = false })

-- FFF search
keymap("n", "<leader><Tab>", function()
  require("fff").find_files()
end, { desc = "Find files" })
keymap("n", "<C-p>", function()
  require("fff").find_files()
end, { desc = "Find files" })
keymap("n", "<leader>f", function()
  require("fff").live_grep()
end, { desc = "Search file contents" })
keymap("n", "<leader>b", function()
  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buflisted
      and vim.api.nvim_buf_get_name(buf) ~= ""
  end, vim.api.nvim_list_bufs())
  vim.ui.select(buffers, {
    prompt = "Buffers",
    format_item = function(buf)
      return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
    end,
  }, function(buf)
    if buf then
      vim.api.nvim_set_current_buf(buf)
    end
  end)
end, { desc = "Choose buffer" })

-- Tab management
keymap("n", "tt", ":tab split<CR>", opts)
keymap("n", "th", ":tabprevious<CR>", opts)
keymap("n", "tl", ":tabnext<CR>", opts)
keymap("n", "t1", "1gt", opts)
keymap("n", "t2", "2gt", opts)
keymap("n", "t3", "3gt", opts)
keymap("n", "t4", "4gt", opts)
keymap("n", "t5", "5gt", opts)
keymap("n", "t6", "6gt", opts)
keymap("n", "t7", "7gt", opts)
keymap("n", "t8", "8gt", opts)
keymap("n", "t9", "9gt", opts)
keymap("n", "t0", ":tablast<CR>", opts)

-- Splits
keymap("n", "<leader>v", ":vsplit<CR>", opts)
keymap("n", "<leader>h", ":split<CR>", opts)

-- ESC alternative
keymap("i", "jk", "<Esc>", opts)

-- Insert current date/time (Ctrl+T in insert mode)
keymap("i", "<C-t>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local date = vim.fn.strftime("%Y/%m/%d %H:%M:%S")
  vim.api.nvim_put({ date }, "c", true, true)
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #date })
end, { noremap = true, silent = true })

-- Insert current date/time (Ctrl+T in insert mode)
keymap("i", "<C-d>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local date = vim.fn.strftime("%Y/%m/%d")
  vim.api.nvim_put({ date }, "c", true, true)
  vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] + #date })
end, { noremap = true, silent = true })

-- Toggle inlay hints
keymap("n", "<leader>ih", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { noremap = true, silent = true, desc = "Toggle inlay hints" })

-- Move forward through the argument list with Ctrl+n; Ctrl+p opens FFF.
vim.keymap.set('n', '<C-n>', ':next<CR>')
