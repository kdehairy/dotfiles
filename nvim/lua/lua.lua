local lsp_utils = require('lsp_config')

require('lazydev').setup({
	enabled = true
})

require 'lspconfig'.lua_ls.setup {
	capabilities = lsp_utils.client_capabilities(),
	on_attach = lsp_utils.on_attach,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		local pack = vim.api.nvim_get_runtime_file("pack/*", true)
		--libs = {vim.env.VIMRUNTIME, table.unpack(pack)}

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					'/home/kdehairy/.local/share/nvim/site/pack/packer/',

					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			},
			completion = {
				keywordSnippet = "Both"
			}
		})
	end,
	settings = {
		Lua = {}
	}
}
--vim.api.nvim_get_runtime_file("pack/*", true)

