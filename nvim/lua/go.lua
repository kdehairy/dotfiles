require('lsp_config')

local nvim_lsp = require('lspconfig')

nvim_lsp.gopls.setup {
	cmd = { 'gopls' },
	-- for postfix snippets and analyzers
	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				useany = true,
				unusedvariable = true,
				shadow = true,
				fieldalignment = true,
			},
			staticcheck = true,
			gofumpt = true,
			usePlaceholders = true,
		},
	},
	on_attach = function(client, bufnr)
		On_attach(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.go" },
			callback = function()
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { "source.organizeImports" } }
				-- buf_request_sync defaults to a 1000ms timeout. Depending on your
				-- machine and codebase, you may want longer. Add an additional
				-- argument after params if you find that you have to write the file
				-- twice for changes to be saved.
				-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
				for cid, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-8"
							vim.lsp.util.apply_workspace_edit(r.edit, enc)
						end
					end
				end
				vim.lsp.buf.format({ async = false })
			end
		})
	end,
}
