-- LSP, DAP servers & debuggers
require('mason').setup()
require('mason-lspconfig').setup {
	ensure_installed = { "gopls", "lua_ls", "rust_analyzer", "terraformls", "tflint" },
	automatic_installation = true
}

-- LSP Diagnostics Options Setup
local sign = function(opts)
	vim.fn.sign_define(opts.name, {
		texthl = opts.name,
		text = opts.text,
		numhl = ''
	})
end

sign({ name = 'DiagnosticSignError', text = 'x' })
sign({ name = 'DiagnosticSignWarn', text = '!' })
sign({ name = 'DiagnosticSignHint', text = '?' })
sign({ name = 'DiagnosticSignInfo', text = 'i' })

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	update_in_insert = true,
	underline = true,
	severity_sort = false,
	float = {
		border = 'rounded',
		source = true,
		header = '',
		prefix = '',
	},
})

-- auto format on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function()
		vim.lsp.buf.format({ async = false })
	end
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

On_attach = function(client, bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

	vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', { buf = bufnr })

	-- Mappings.
	local opts = { noremap = true, silent = true }
	buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
	buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap('n', 'ga', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts)
	buf_set_keymap('n', '<C-space>', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
	buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
	buf_set_keymap('n', '<space>h', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
	buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
	buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
	buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
	buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
	buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
	buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
	buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)



	-- Set some keybinds conditional on server capabilities
	if client.resolved_capabilities then
		if client.resolved_capabilities.document_formatting then
			buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
		elseif client.resolved_capabilities.document_range_formatting then
			buf_set_keymap("n", "ff", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
		end

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

--vim.lsp.set_log_level("debug")