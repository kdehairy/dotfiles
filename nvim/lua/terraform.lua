require('lsp_config')

-- terraform filetype
require("filetype").setup({
	overrides = {
		extensions = {
			tf = "terraform",
			tfvars = "terraform",
			tfstate = "json",
		},
	},
})

-- terraform language server
require('lspconfig').terraformls.setup{
	on_attach =	on_attach
}

