-- null-ls LSP
local null_ls = require("null-ls")
null_ls.setup({
	sources = {
		-- terraform
		null_ls.builtins.formatting.terraform_fmt,
		null_ls.builtins.diagnostics.terraform_validate,
	}
})

