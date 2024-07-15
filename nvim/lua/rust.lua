local extension_path = '/usr/lib/codelldb/'
local codelldb_path = extension_path .. 'adapter/codelldb'
local liblldb_path = extension_path .. 'lldb/lib/liblldb.so'

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

require('dap.ext.vscode').load_launchjs(nil, {rt_lldb={'rust'}})


--[[
local dap = require('dap')
dap.configurations.rust = {
  {
    name = "Launch file",
    type = "rt_lldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
--]]
