local api = require('nvim-tree.api')

require('nvim-tree').setup({
	on_attach = function(bufnr)
		-- default mappings
		api.map.on_attach.default(bufnr)
	end,
	hijack_cursor = true,
	diagnostics = {
		enable = true,
	},
	renderer = {
		highlight_git = 'name',
		highlight_diagnostics = 'name',
		indent_markers = {
			enable = true,
		},
	},
})

-- Registered here rather than in on_attach: these are meant to be reachable from any
-- buffer, and inside on_attach they did not exist until a tree buffer was created.
vim.keymap.set('n', '<Leader>tt', api.tree.toggle, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tf', api.tree.find_file, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>tc', function()
	api.tree.collapse_all({ keep_buffers = true })
end, { noremap = true, silent = true })

local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1
	if not directory then
		return
	end
	-- change to the directory
	vim.cmd.cd(data.file)
	-- open the tree
	api.tree.open()
end

vim.api.nvim_create_autocmd({ 'VimEnter' }, { callback = open_nvim_tree })
