local lsp_utils = require('lsp_config')
local rust_config = require('rustaceanvim.config')

local codelldb_path = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb'
local liblldb_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so'

vim.g.rustaceanvim = {
	server = {
		on_attach = lsp_utils.on_attach
	},
	dap = {
		adapter = rust_config.get_codelldb_adapter(codelldb_path, liblldb_path)
	}
}
