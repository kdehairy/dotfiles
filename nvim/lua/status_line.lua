local lualine = require('lualine')

local configs = lualine.get_config()

configs.options.theme = 'codedark'
configs.options.component_separators = { left = '|', right = '|' }
configs.options.section_separators = { left = '', right = '' }
configs.options.disabled_filetypes = {
	statusline = { 'NvimTree' }
}
configs.sections.lualine_a = {
	{ 'mode', fmt = function(str) return str:sub(1, 1) end },
}
configs.sections.lualine_c = {
	{ 'filename', path = 3 },
}

lualine.setup(configs)
