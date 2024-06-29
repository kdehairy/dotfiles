require('lsp_config')

-- terraform language server
require('lspconfig').terraformls.setup {
	on_attach = function(client, bufnr)
		On_attach(client, bufnr)
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.tf", "*.tfvars" },
			callback = vim.lsp.buf.format({ async = false }),
		})
	end,
}
