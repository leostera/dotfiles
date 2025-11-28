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

-- FZF
keymap("n", "<leader><Tab>", ":FZF<CR>", opts)
keymap("n", "<C-p>", ":Files<CR>", opts)
keymap("n", "<leader>f", ":Rg<CR>", opts)
keymap("n", "<leader>b", ":Buffers<CR>", opts)
