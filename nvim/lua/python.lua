local lsp_utils = require('lsp_config')
local nvim_lsp = vim.lsp.config

nvim_lsp.pyright = {
	on_attach = lsp_utils.on_attach
}
