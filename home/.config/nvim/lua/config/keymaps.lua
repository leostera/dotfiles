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
keymap("n", "<leader><leader>c", "gcc", { remap = true })
keymap("v", "<leader><leader>c", "gc", { remap = true })

-- FZF
keymap("n", "<leader><Tab>", ":FZF<CR>", opts)
keymap("n", "<C-p>", ":Files<CR>", opts)
keymap("n", "<leader>f", ":Rg<CR>", opts)
keymap("n", "<leader>b", ":Buffers<CR>", opts)

-- Tab management
keymap("n", "tt", ":tabnew<CR>", opts)
keymap("n", "tl", ":tabnext<CR>", opts)
keymap("n", "tr", ":tabprevious<CR>", opts)
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
