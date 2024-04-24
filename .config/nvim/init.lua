-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[
	let mapleader=";"

	set nocompatible

	" indentation
	set shiftwidth=2
	set tabstop=2
	set softtabstop=2
	set autoindent

	set ruler
	set cursorline

	" seach
	set incsearch
	set ignorecase
	set smartcase

	" treesitter
	set nofoldenable

	" splits
	nmap <C-h> :vertical res +5 <CR>
	nmap <C-l> :vertical res -5 <CR>
	nmap <C-j> :res +5 <CR>
	nmap <C-k> :res -5 <CR>

	" copy to clipboard
	noremap <Leader>y "+y
	noremap <Leader>p "+p

	" format xml
	com! FormatXml :%!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
]])

require('plugins')

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Cobalt color theme
require('colorbuddy').colorscheme('cobalt2')

-- nvim-tree setup
require('nvim_tree')

require('lsp_config')

require('lua')

require('rust')

require('go')

require('null_ls')

require('auto_completion')

require('tree_sitter')
