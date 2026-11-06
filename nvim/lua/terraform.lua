local lsp_utils = require('lsp_config')

-- terraform language server
vim.lsp.config.terraformls = {
	capabilities = lsp_utils.client_capabilities(),
	on_attach = function(client, bufnr)
		lsp_utils.on_attach(client, bufnr)
		local group = vim.api.nvim_create_augroup('terraform_format', { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			group = group,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format({ async = false })
			end
		})
	end,
}

vim.lsp.enable('terraformls')
