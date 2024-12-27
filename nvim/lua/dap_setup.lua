require('dapui').setup {
	layouts = {
		{
			elements = {
				{ id = "scopes", size = 0.75} ,
				{ id = "watches", size = 0.25 },
			},
			size = 40,
			position = "right",
		},
		{
			elements = {
				{ id = "stacks", size = 0.75 },
				{ id = "repl", size = 0.25 },
			},
			size = 10,
			position = "bottom",
		},
	},
}

local dap, dapui = require('dap'), require('dapui')
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

vim.keymap.set('n', '<F5>', function() dap.continue() end)
vim.keymap.set('n', '<F8>', function() dap.step_over() end)
vim.keymap.set('n', '<F7>', function() dap.step_into() end)
vim.keymap.set('n', '<F9>', function() dap.close(); dapui.close() end)
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<leader>de', function() dapui.eval() end)
vim.keymap.set('v', '<leader>de', function() dapui.eval() end)
