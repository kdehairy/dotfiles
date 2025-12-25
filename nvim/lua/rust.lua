local lsp_utils = require('lsp_config')

local function rust_on_attach(client, bufnr)
	lsp_utils.on_attach(client, bufnr)
	local opts = { silent = true, noremap = true, buffer = bufnr }
	vim.keymap.set("n", "<F5>",
		function()
			vim.cmd.RustLsp('runnables')
		end,
		opts
	)

	vim.keymap.set("n", "<F10>",
		function()
			vim.cmd.RustLsp('testables')
		end,
		opts
	)

	vim.keymap.set("n", "ga",
		function()
			vim.cmd.RustLsp('codeAction')
		end,
		opts
	)
end

vim.g.rustaceanvim = {
	server = {
		on_attach = rust_on_attach
	},
}
