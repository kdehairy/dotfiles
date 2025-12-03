local lsp_utils = require('lsp_config')
local rust_config = require('rustaceanvim.config')

local codelldb_path = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb'
local liblldb_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so'

local function rust_on_attach(client, bufnr)
	lsp_utils.on_attach(client, bufnr)
	local opts = { silent = true, noremap = true, buffer = bufnr }
	vim.keymap.set("n", "<F5>",
		function()
			vim.cmd.RustLsp('runnables')
		end,
		opts
	)

	vim.keymap.set("n", "<F10>",
		function()
			vim.cmd.RustLsp('testables')
		end,
		opts
	)

	vim.keymap.set("n", "ga",
		function()
			vim.cmd.RustLsp('codeAction')
		end,
		opts
	)
end

vim.g.rustaceanvim = {
	server = {
		on_attach = rust_on_attach
	},
	dap = {
		adapter = rust_config.get_codelldb_adapter(codelldb_path, liblldb_path)
	},
}
