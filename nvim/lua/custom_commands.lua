-- format xml
vim.api.nvim_create_user_command('Fmtxml',
	':%!python -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"', {})
-- format json
vim.api.nvim_create_user_command('Fmtjson',
	':%!python -m jsontool', {})
