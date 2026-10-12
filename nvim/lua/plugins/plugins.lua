return {
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-tree/nvim-tree.lua" },
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
	{ "mason-org/mason.nvim" },
	{ "mason-org/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{ "mrcjkb/rustaceanvim" },
	{ "jose-elias-alvarez/null-ls.nvim" },
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
	},
	{ "folke/lazydev.nvim" },
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			{ "L3MON4D3/LuaSnip", version = "v2.*", dependencies = { "rafamadriz/friendly-snippets" }, build = "make install_jsregexp" },
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons"
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		--config = function()
		--	local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
		--	ts_update()
		--end,
	},
	{ "lewis6991/gitsigns.nvim" },
	{ "sindrets/diffview.nvim" },
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {},
	},
}
