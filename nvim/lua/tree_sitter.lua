-- Parsers to keep installed. This branch installs nothing implicitly -- `ensure_installed` and
-- `auto_install` no longer exist -- so a new language means a name here or a manual `:TSInstall`.
-- The call is asynchronous and skips parsers already in stdpath('data')/site/parser, so a warm
-- machine does no work; `build = ':TSUpdate'` in plugins.lua keeps them current.
require('nvim-treesitter').install({
	'bash',
	'c',
	'go',
	'json',
	'lua',
	'python',
	'rust',
	'toml',
	'vim',
	'vimdoc',
	'yaml',
})

-- Highlighting and folding are both opt-in per filetype on this branch: the rewrite dropped the
-- `highlight = { enable = true }` module, and features are "not automatically enabled". Folding is
-- the form the nvim-treesitter README documents -- `v:lua.vim.treesitter.foldexpr()`, not the
-- removed `nvim_treesitter#foldexpr()` (that call only raised E117, which foldexpr swallows, so
-- folding silently never happened). `start()` errors for filetypes without a parser, hence pcall;
-- folding is configured only where it succeeded, leaving parser-less buffers on their own
-- foldmethod rather than forcing `expr` on them.
local ts_group = vim.api.nvim_create_augroup('TREESITTER', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = ts_group,
	callback = function()
		if not pcall(vim.treesitter.start) then
			return
		end
		vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
		vim.wo[0][0].foldmethod = 'expr'
	end,
})
