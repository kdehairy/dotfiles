return require('packer').startup(function(use)
	-- Packer itself
	use 'wbthomason/packer.nvim'

	-- lua
	use "nvim-lua/plenary.nvim"

	-- nvim-tree
	use 'nvim-tree/nvim-tree.lua'

	-- Cobalt color theme
	use { 'lalitmee/cobalt2.nvim', requires = 'tjdevries/colorbuddy.nvim' }
	use { 'folke/tokyonight.nvim' }

	--LSP, DAP servers, and linters
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig'
	use 'simrat39/rust-tools.nvim'
	use 'jose-elias-alvarez/null-ls.nvim'

	-- Completion framework:
	use 'hrsh7th/nvim-cmp'

	-- LSP completion source:
	use 'hrsh7th/cmp-nvim-lsp'

	-- Useful completion sources:
	use 'hrsh7th/cmp-nvim-lua'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-vsnip'
	use 'hrsh7th/cmp-path'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/vim-vsnip'

	-- filetype
	-- use 'nathom/filetype.nvim'

	-- tree-sitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
end)
