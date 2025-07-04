local opt        = vim.opt
local g          = vim.g

g.mapleader      = ","
g.maplocalleader = "\\"

opt.compatible   = false
opt.number       = true
opt.autoread     = true

opt.autoindent   = true
opt.smartindent  = true
opt.smarttab     = true
opt.tabstop      = 2
opt.expandtab    = true
opt.shiftwidth   = 2
opt.softtabstop  = 2
opt.signcolumn   = "yes"

local key        = vim.api.nvim_set_keymap
local keyopts    = { noremap = true, silent = true }
--  Key mappings for navigation
key("n", "<C-H>", "<C-W>h", keyopts)
key("n", "<C-J>", "<C-W>j", keyopts)
key("n", "<C-K>", "<C-W>k", keyopts)
key("n", "<C-L>", "<C-W>l", keyopts)
key("n", "<C-->", "<C-W><S-->", keyopts)
key("n", "<C-=>", "<C-W>=", keyopts)

-- Tab navigation
key("n", "tt", ":tabnew<CR>", keyopts)
key("n", "th", ":tabp<CR>", keyopts)
key("n", "tl", ":tabn<CR>", keyopts)

-- Key mappings for general actions
key("i", "jk", "<ESC>:w<CR>", keyopts)
key("n", "<leader>x", ":set paste!<CR>", keyopts)
key("n", "<leader>s", ":set spell!<CR>", keyopts)
key("n", "<leader>1", ":set number!<CR>", keyopts)
key("n", "<leader><space>", ":noh<CR>", keyopts)
key("n", "<leader>v", ":vsp<CR>", keyopts)
key("n", "<leader>h", ":split<CR>", keyopts)

-- Key mappins for my own sanity
key("n", "Q", "<NOP>", keyopts) --disable ex mode
