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


-- lsp_utils module
local lsp_utils = {}

function lsp_utils.client_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	-- allow for snippets
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

function lsp_utils.on_attach(client, bufnr)
	vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })


	-- Mappings
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
	map('n', 'ff', function() vim.lsp.buf.format({async = false}) end)


	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities then
		-- Set autocommands conditional on server_capabilities
		if client.resolved_capabilities.resolved_capabilities.document_highlight then
			vim.api.nvim_exec2([[
      hi LspReferenceRead cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], { output = false })
		end
	end
end

return lsp_utils
