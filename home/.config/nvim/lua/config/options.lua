-- Leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.mouse = "a"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Visual
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = false
vim.opt.scrolloff = 8

-- Folding
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"

-- Completion
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.shortmess:append("c")

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- File handling
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Performance
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Filetype-specific settings
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.caramel",
  callback = function()
    vim.bo.syntax = "rust"
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.core",
  callback = function()
    vim.bo.syntax = "erlang"
  end,
})
