require("base")
require("deps")
require("plugins.lsp")

-- Automatic filetype detection for .newt files
vim.api.nvim_command [[autocmd BufNewFile,BufRead *.newt setfiletype newt]]
require("lang.newt")

local lsp = require'lspconfig'
lsp["ocamllsp"].setup{
  cmd = { "tusk", "lsp" },
}
