local codelldb_path = vim.env.HOME .. '/.local/share/nvim/mason/bin/codelldb'
local liblldb_path = vim.env.HOME .. '/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so'

local rt = require('rust-tools')
local lsp_utils = require('lsp_config')
rt.setup({
	capabilities = lsp_utils.client_capabilities(),
	server = {
		on_attach = lsp_utils.on_attach,
		capabilities = lsp_utils.client_capabilities(),
	},
	dap = {
		adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb_path, liblldb_path)
	}
})

local dap = require('dap')


dap.adapters.codelldb = {
	type = 'server',
	port = "${port}",
	executable = {
		command = codelldb_path,
		args = { "--port", "${port}", "--liblldb", liblldb_path },
	}
}

dap.configurations.rust = {
	{
		name = "Launch file",
		type = "codelldb",
		request = "launch",
		program = function()
			return require('dap.utils').pick_file({ path = vim.fn.getcwd() .. '/target/debug' })
		end,
		args = function()
			local t = {}
			local args = vim.fn.input('Args: ')
			for arg in args:gmatch("%S+") do
				table.insert(t, arg)
			end
			return t
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
	},
	{
		name = "Wait for Process",
		type = "codelldb",
		request = "attach",
		program = function()
			return require('dap.utils').pick_file({ path = vim.fn.getcwd() .. '/target/debug' })
		end,
		--pid = require('dap.utils').pick_process,
		waitFor = true,
	},
	{
		name = "Attach to Process",
		type = "codelldb",
		request = "attach",
		program = function()
			return require('dap.utils').pick_file({ path = vim.fn.getcwd() .. '/target/debug' })
		end,
		waitFor = false,
	},
}
