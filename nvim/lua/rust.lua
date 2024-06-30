local rt = require('rust-tools')
local lsp_utils = require('lsp_config')
rt.setup({
	server = {
		on_attach = lsp_utils.on_attach,
		capabilities = lsp_utils.client_capabilities(),
	},
})
