local lsp_utils = require('lsp_config')
local nvim_lsp = vim.lsp.config

nvim_lsp.gopls = {
	cmd = { 'gopls' },
	capabilities = lsp_utils.client_capabilities(),
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				useany = true,
				unusedvariable = true,
				shadow = true,
			},
			staticcheck = true,
			gofumpt = true,
			usePlaceholders = true,
		},
	},
	on_attach = function(client, bufnr)
		lsp_utils.on_attach(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.go" },
			callback = function()
				local enc = client.offset_encoding or "utf-8"
				local range_params = vim.lsp.util.make_range_params(0, "utf-8")
				local params = vim.tbl_deep_extend("keep",
					{ context = { only = { "source.organizeImports" } } },
					range_params)
				-- buf_request_sync defaults to a 1000ms timeout. Depending on your
				-- machine and codebase, you may want longer. Add an additional
				-- argument after params if you find that you have to write the file
				-- twice for changes to be saved.
				-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
				for cid, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-8"
							vim.lsp.util.apply_workspace_edit(r.edit, enc)
						end
					end
				end
				vim.lsp.buf.format({ async = false })
			end
		})
	end,
}

local dap = require('dap')
dap.adapters.delve = function(callback, config)
	if config.mode == 'remote' and config.request == 'attach' then
		callback({
			type = 'server',
			host = config.host or '127.0.0.1',
			port = config.port or '38697'
		})
	else
		callback({
			type = 'server',
			port = '${port}',
			executable = {
				command = 'dlv',
				args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
				detached = vim.fn.has("win32") == 0,
			}
		})
	end
end

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
	{
		type = "delve",
		name = "Debug",
		request = "launch",
		program = "${file}"
	},
	{
		type = "delve",
		name = "Debug test", -- configuration for debugging test files
		request = "launch",
		mode = "test",
		program = "${file}"
	},
	-- works with go.mod packages and sub packages
	{
		type = "delve",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}"
	}
}

vim.lsp.enable('gopls')
