-- LSP, DAP servers & debuggers
require('mason').setup()
require('mason-lspconfig').setup {
	ensure_installed = { "gopls", "lua_ls", "rust_analyzer", "terraformls", "tflint" },
	automatic_installation = true
}

-- LSP Diagnostics Options Setup
vim.diagnostic.config({
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = 'x',
			[vim.diagnostic.severity.WARN]  = '!',
			[vim.diagnostic.severity.INFO]  = 'i',
			[vim.diagnostic.severity.HINT]  = '?',
		},
	},
	underline = true,
	severity_sort = true,
	float = {
		severity_sort = true,
		scope = 'cursor',
		border = 'single',
		source = true,
		header = '',
		prefix = '',
	},
})

-- Add borders to the hover and signature_help floating window
vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_hover] = vim.lsp.with(
	vim.lsp.handlers.hover,
	{ border = 'single' }
)
vim.lsp.handlers[vim.lsp.protocol.Methods.textDocument_signatureHelp] = vim.lsp.with(
	vim.lsp.handlers.signature_help,
	{ border = 'single' }
)


-- lsp_utils module
local lsp_utils = {}

function lsp_utils.client_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- allow for snippets
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

---@param client vim.lsp.Client lsp client
---@param bufnr integer buffer number
function lsp_utils.on_attach(client, bufnr)
	vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })


	-- Mappings
	---@param mode string
	---@param lhs string
	---@param rhs function
	---@param opts? vim.keymap.set.Opts
	local function map(mode, lhs, rhs, opts)
		opts = opts or { noremap = true, silent = true }
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end
	map('n', 'gD', function() vim.lsp.buf.declaration() end)
	map('n', 'gd', function() vim.lsp.buf.definition() end)
	map('n', 'ga', function() vim.lsp.buf.code_action() end)
	map('n', '<C-space>', function() vim.lsp.buf.hover() end)
	map('n', 'gi', function() vim.lsp.buf.implementation() end)
	map('n', '<space>h', function() vim.lsp.buf.signature_help() end)
	map('n', '<space>wa', function() vim.lsp.buf.add_workspace_folder() end)
	map('n', '<space>wr', function() vim.lsp.buf.remove_workspace_folder() end)
	map('n', '<space>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end)
	map('n', '<space>D', function() vim.lsp.buf.type_definition() end)
	map('n', '<space>rn', function() vim.lsp.buf.rename() end)
	map('n', 'gr', function() vim.lsp.buf.references() end)
	map('n', '[d', function() vim.diagnostic.goto_prev() end)
	map('n', ']d', function() vim.diagnostic.goto_next() end)
	map('n', 'ff', function() vim.lsp.buf.format({ async = false }) end)


	-- Document Hightlighting
	if client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
		vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Search' })
		vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Search' })
		vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Search' })
		local group = vim.api.nvim_create_augroup('highlight_symbol', { clear = false })
		vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
		vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.document_highlight,
		})
		vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
			group = group,
			buffer = bufnr,
			callback = vim.lsp.buf.clear_references,
		})
	end

	--Inlay hints
	if client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

return lsp_utils
