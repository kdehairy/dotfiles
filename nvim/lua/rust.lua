local rt = require('rust-tools')
rt.setup({
	server = {
		on_attach = On_attach
	}
})
