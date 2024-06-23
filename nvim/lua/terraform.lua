require('lsp_config')

-- terraform language server
require('lspconfig').terraformls.setup {
	on_attach = On_attach
}
