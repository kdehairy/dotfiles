return require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	-- lua
	use "nvim-lua/plenary.nvim"

	-- nvim-tree
	use 'nvim-tree/nvim-tree.lua'

	-- color theme
	use { 'folke/tokyonight.nvim' }

	--LSP, DAP servers, and linters
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig'
	use 'simrat39/rust-tools.nvim'
	use 'jose-elias-alvarez/null-ls.nvim'

	-- Completion framework:
	use 'hrsh7th/nvim-cmp'


	-- --------------------------
	-- Useful completion sources:
	-- --------------------------
	-- LSP completion source:
	use 'hrsh7th/cmp-nvim-lsp'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-nvim-lua'
	-- snippets
	use {
		'L3MON4D3/LuaSnip',
		tag = 'v2.*',
		requires = { "rafamadriz/friendly-snippets" },
	}
	use 'saadparwaiz1/cmp_luasnip'

	-- lualine
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}

	-- tree-sitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}

	-- git
	use 'lewis6991/gitsigns.nvim'
	use 'sindrets/diffview.nvim'
end)
