return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { "lua_ls", "rust_analyzer", "bashls", "clangd", "dockerls", "elixirls", "erlangls", "gopls", "rescriptls", "taplo" }
      })
    end
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      local actions = null_ls.builtins.code_actions
      local completion = null_ls.builtins.completion
      local formatting = null_ls.builtins.formatting

      null_ls.setup({
        sources = {
          formatting.stylua,
        },
      })
    end,
  },
  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {}, -- required, even if empty
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lsp = require('lspconfig')

      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

      vim.keymap.set('n', '<leader>F', vim.lsp.buf.format, bufopts)


      lsp.lua_ls.setup({})
    end
  },
  require('lang/rust'),
}
