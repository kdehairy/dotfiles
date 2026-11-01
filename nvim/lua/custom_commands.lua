-- Run a formatter over the whole buffer and replace the text only when the command
-- succeeds.
---@param cmd string[] formatter argv; reads stdin, writes formatted text to stdout
---@param name string command name, used in the error message
local function format_buffer(cmd, name)
	if vim.fn.executable(cmd[1]) ~= 1 then
		vim.notify(name .. ': ' .. cmd[1] .. ' is not installed', vim.log.levels.ERROR)
		return
	end

	local buf = vim.api.nvim_get_current_buf()
	local input = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), '\n') .. '\n'
	local result = vim.system(cmd, { text = true, stdin = input }):wait()

	if result.code ~= 0 then
		local err = (result.stderr or ''):gsub('\n+$', '')
		vim.notify(name .. ': ' .. (err ~= '' and err or ('exited with code ' .. result.code)),
			vim.log.levels.ERROR)
		return
	end

	local out = (result.stdout or ''):gsub('\n+$', '')
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(out, '\n'))
end

-- format xml
vim.api.nvim_create_user_command('Fmtxml', function()
	format_buffer({ 'xmllint', '--format', '-' }, 'Fmtxml')
end, { desc = 'Pretty-print the buffer as XML' })

-- format json
vim.api.nvim_create_user_command('Fmtjson', function()
	format_buffer({ 'jq', '.' }, 'Fmtjson')
end, { desc = 'Pretty-print the buffer as JSON' })
