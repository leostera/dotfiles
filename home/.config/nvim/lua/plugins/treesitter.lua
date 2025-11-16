return {
	'nvim-treesitter/nvim-treesitter',
	build = ":TSUpdate",
	config = function()
		-- Syntax
		local treesitter = require("nvim-treesitter.configs")
		treesitter.setup({
			auto_install = true,
			highlight = { enable=true },
			indent = { enable=true },
		})

	end
}
