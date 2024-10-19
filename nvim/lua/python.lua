local lsp_utils = require('lsp_config')
local nvim_lsp = require('lspconfig')

nvim_lsp.pyright.setup {
	on_attach = lsp_utils.on_attach
}
