return {
	{
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8', 
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	    local telescope = require("telescope.builtin")
	    vim.keymap.set('n', '<leader><tab>', telescope.find_files, { desc = 'Telescope find files' })
	    vim.keymap.set('n', '<leader>r', telescope.live_grep, { desc = 'Telescope live grep' })
	    vim.keymap.set('n', '<leader>b', telescope.buffers, { desc = 'Telescope buffers' })
	    vim.keymap.set('n', '<leader>ht', telescope.help_tags, { desc = 'Telescope help tags' })
    end
},

{ 'nvim-telescope/telescope-ui-select.nvim',
config = function()
	require("telescope").setup({extensions = { ["ui-select"] = { require('telescope.themes').get_dropdown {} }}})
	require('telescope').load_extension('ui-select')
end
}
}
