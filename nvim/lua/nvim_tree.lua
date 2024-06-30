require("nvim-tree").setup({
	on_attach = function(bufnr)
		local api = require("nvim-tree.api")
		-- default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- custom mappings
		local function map(mode, lhs, rhs, opts)
			opts = opts or { noremap = true, silent = true }
			vim.keymap.set(mode, lhs, rhs, opts)
		end
		map('n', '<Leader>tt', api.tree.toggle)
		map('n', '<Leader>tf', api.tree.find_file)
		map('n', '<Leader>tc', function() api.tree.collapse_all(true) end)
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
		}
	},
})

local function open_nvim_tree(data)
	-- buffer is a directory
	local directory = vim.fn.isdirectory(data.file) == 1
	if not directory then
		return
	end
	-- change to the directory
	vim.cmd.cd(data.file)
	-- open the tree
	local api = require("nvim-tree.api")
	api.tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
