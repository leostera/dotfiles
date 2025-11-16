-- Configure the newt parser for nvim-treesitter
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

parser_config.newt = {
  install_info = {
    url = "/Users/ostera/Developer/github.com/leostera/newt/crates/tree-sitter-newt/",
    files = {"src/parser.c"},
    generate_requires_npm = false,
    requires_generate_from_grammar = false,
  },
  filetype = "newt",
  maintainers = { "@leostera" },
}

-- Configure nvim-treesitter to automatically enable features for newt
require('nvim-treesitter.configs').setup {
  ensure_installed = { "newt" }, -- Auto-install newt parser
  auto_install = true, -- Auto-install missing parsers when entering buffer

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  -- Enable other features as they become available
  indent = { enable = true },
  incremental_selection = { enable = true },
}

-- Configure LSP for Newt
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')

-- Define the newt LSP configuration
if not configs.newt_lsp then
  configs.newt_lsp = {
    default_config = {
      cmd = { '/Users/ostera/Developer/github.com/leostera/newt/target/debug/newt', 'lsp' },
      filetypes = { 'newt' },
      root_dir = function(fname)
        return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
      end,
      settings = {},
      init_options = {
        enable_type_checking = true,
        enable_diagnostics = true,
      },
    },
  }
end

-- Start the LSP for newt files
lspconfig.newt_lsp.setup({
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Key mappings for LSP features
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
    
    -- Show diagnostics in a floating window
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, bufopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bufopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, bufopts)
  end,
  
  -- Enable capabilities from nvim-cmp if you have it
  capabilities = (function()
    local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if has_cmp then
      return cmp_nvim_lsp.default_capabilities()
    else
      return vim.lsp.protocol.make_client_capabilities()
    end
  end)(),
})

-- Set up filetype detection for .newt files (if not already done)
vim.filetype.add({
  extension = {
    newt = 'newt',
  },
})
