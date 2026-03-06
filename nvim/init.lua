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

-- floating window border
vim.o.winborder = 'rounded'

--splits
vim.keymap.set('n', '<S-Right>', ':vertical res +5<cr>')
vim.keymap.set('n', '<S-Left>', ':vertical res -5<cr>')
vim.keymap.set('n', '<S-Up>', ':res +5<cr>')
vim.keymap.set('n', '<S-Down>', ':res -5<cr>')

--copy to clipboard
vim.keymap.set({ 'n', 'v' }, '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>yy', '"+yy')
vim.keymap.set('n', '<Leader>p', '"+p')

require('config.lazy')

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require('custom_commands')

-- nvim-tree setup
require('nvim_tree')

require('lsp_config')

require('dap_setup')

require('lua')

require('rust')

require('go')

require('python')

-- require('null_ls')

require('terraform')

require('auto_completion')

require('tree_sitter')

require('git')

require('status_line')

require('movement').setup {}
