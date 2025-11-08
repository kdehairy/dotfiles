local lsp_utils = require('lsp_config')

require('lazydev').setup({
	enabled = true
})

vim.lsp.config.lua_ls = {
	capabilities = lsp_utils.client_capabilities(),
	filetypes = {'lua'},
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		".git",
	},
	on_attach = lsp_utils.on_attach,
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				version = 'LuaJIT',
				path = {
					'lua/?.lua',
					'lua/?/init.lua',
				},
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				}
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

vim.lsp.enable('lua_ls')
