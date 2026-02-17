-- Always format Python files on save via Ruff LSP
vim.api.nvim_create_autocmd("BufWritePre", {
  buffer = 0,
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local has_ruff = false
    for _, client in ipairs(clients) do
      if client.name == "ruff" then
        has_ruff = true
        break
      end
    end

    if has_ruff then
      vim.lsp.buf.format({
        async = false,
        filter = function(client)
          return client.name == "ruff"
        end,
      })
    else
      vim.lsp.buf.format({ async = false })
    end

    pcall(vim.cmd, "LspPyrightOrganizeImports")
  end,
})
