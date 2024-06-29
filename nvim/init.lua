-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = ";"

vim.o.compatible = false

-- indentation
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.autoindent = true


vim.o.ruler = true
vim.o.cursorline = true

-- search
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- treesitter
vim.o.foldenable = false

--splits
vim.keymap.set('n', '<C-h>', ':vertical res +5<cr>')
vim.keymap.set('n', '<C-l>', ':vertical res -5<cr>')
vim.keymap.set('n', '<C-j>', ':vertical res +5<cr>')
vim.keymap.set('n', '<C-l>', ':vertical res -5<cr>')

--copy to clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>yy', '"+yy')
vim.keymap.set('n', '<Leader>p', '"+p')

-- format xml
vim.api.nvim_create_user_command('Fmtxml',
	':%!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"', {})
-- format json
vim.api.nvim_create_user_command('Fmtjson',
	':%!python -m jsontool', {})


require('plugins')

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Cobalt color theme
-- require('colorbuddy').colorscheme('cobalt2')
vim.cmd([[colorscheme tokyonight]])

-- nvim-tree setup
require('nvim_tree')

require('lsp_config')

require('lua')

require('rust')

require('go')

require('null_ls')

require('terraform')

require('auto_completion')

require('tree_sitter')

require('git')
