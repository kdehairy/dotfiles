local lsp_utils = require('lsp_config')

-- terraform language server
require('lspconfig').terraformls.setup {
	capabilities = lsp_utils.client_capabilities(),
	on_attach = function(client, bufnr)
		lsp_utils.on_attach(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.tf", "*.tfvars" },
			callback = function()
				vim.lsp.buf.format({ async = false })
			end
		})
	end,
}
