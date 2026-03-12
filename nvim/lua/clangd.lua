local lsp_config = require('lsp_config')

local default_on_attach = vim.lsp.config['clangd'].on_attach


local function clang_on_attach(client, bufnr)
	if default_on_attach ~= nil then
		default_on_attach(client, bufnr)
	end
	lsp_config.on_attach(client, bufnr)
end

vim.lsp.config.clangd = {
	on_attach = clang_on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    -- This MUST be here, not in the .clangd file:
    "--query-driver=/home/kdehairy/.platformio/packages/**/bin/*-g*",
	}
}

vim.lsp.enable('clangd')
