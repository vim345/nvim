require("mason").setup()

require("mason-nvim-dap").setup({
	ensure_installed = { "delve" },
})

local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	print("nvim-dap not installed!")
	return
end

require("dap").set_log_level("INFO") -- Helps when configuring DAP, see logs with :DapShowLog

dap.configurations = {
	go = {
		{
			type = "go", -- Which adapter to use
			name = "Debug", -- Human readable name
			request = "launch", -- Whether to "launch" or "attach" to program
			program = "${file}", -- The buffer you are focused on when running nvim-dap
		},
	},
}

dap.adapters.go = {
	type = "server",
	port = "${port}",
	executable = {
		command = vim.fn.stdpath("data") .. "/mason/bin/dlv",
		args = { "dap", "-l", "127.0.0.1:${port}" },
	},
}
local dap_ui_ok, ui = pcall(require, "dapui")
if not (dap_ok and dap_ui_ok) then
	require("notify")("dap-ui not installed!", "warning")
	return
end

ui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	expand_lines = vim.fn.has("nvim-0.7"),
	layouts = {
		{
			elements = {
				"scopes",
			},
			size = 0.3,
			position = "right",
		},
		-- {
		--   elements = {
		--     "repl",
		--     "breakpoints"
		--   },
		--   size = 0.3,
		--   position = "bottom",
		-- },
	},
	floating = {
		max_height = nil,
		max_width = nil,
		border = "single",
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
	render = {
		max_type_length = nil,
	},
})

local dap_ok, dap = pcall(require, "dap")
local dap_ui_ok, ui = pcall(require, "dapui")

if not (dap_ok and dap_ui_ok) then
	require("notify")("nvim-dap or dap-ui not installed!", "warning") -- nvim-notify is a separate plugin, I recommend it too!
	return
end

vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

-- Start debugging session
vim.keymap.set("n", "<F7>", function()
	dap.continue()
	ui.toggle({})
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
end)

-- Set breakpoints, get variable values, step into/out of functions, etc.
vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
vim.keymap.set("n", "<localleader>dc", dap.continue)
vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<localleader>dn", dap.step_over)
vim.keymap.set("n", "<localleader>di", dap.step_into)
vim.keymap.set("n", "<localleader>do", dap.step_out)
vim.keymap.set("n", "<localleader>dC", function()
	dap.clear_breakpoints()
	require("notify")("Breakpoints cleared", "warn")
end)

-- Close debugger and clear breakpoints
vim.keymap.set("n", "<localleader>de", function()
	dap.clear_breakpoints()
	ui.toggle({})
	dap.terminate()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
	require("notify")("Debugger session ended", "warn")
end)

local go = {
	{
		type = "go",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "go",
		name = "Debug test (go.mod)",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	{
		type = "go",
		name = "Attach (Pick Process)",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "go",
		name = "Attach (127.0.0.1:9080)",
		mode = "remote",
		request = "attach",
		port = "9080",
	},
}

local java = {
	{
		type = "java",
		name = "Debug",
		request = "launch",
		program = "${file}",
	},
	{
		type = "java",
		name = "Debug test ",
		request = "launch",
		mode = "test",
		program = "./${relativeFileDirname}",
	},
	{
		type = "java",
		name = "Attach (Pick Process)",
		mode = "local",
		request = "attach",
		processId = require("dap.utils").pick_process,
	},
	{
		type = "java",
		name = "Attach (127.0.0.1:9090)",
		mode = "remote",
		request = "attach",
		port = "9080",
	},
}

require("dap-go").setup({
	-- Additional dap configurations can be added.
	-- dap_configurations accepts a list of tables where each entry
	-- represents a dap configuration. For more details do:
	-- :help dap-configuration
	dap_configurations = {
		{
			-- Must be "go" or it will be ignored by the plugin
			type = "go",
			name = "Attach remote",
			mode = "remote",
			request = "attach",
		},
	},
	-- delve configurations
	delve = {
		-- the path to the executable dlv which will be used for debugging.
		-- by default, this is the "dlv" executable on your PATH.
		path = "dlv",
		-- time to wait for delve to initialize the debug session.
		-- default to 20 seconds
		initialize_timeout_sec = 20,
		-- a string that defines the port to start delve debugger.
		-- default to string "${port}" which instructs nvim-dap
		-- to start the process in a random available port
		port = "${port}",
		-- additional args to pass to dlv
		args = {},
		-- the build flags that are passed to delve.
		-- defaults to empty string, but can be used to provide flags
		-- such as "-tags=unit" to make sure the test suite is
		-- compiled during debugging, for example.
		-- passing build flags using args is ineffective, as those are
		-- ignored by delve in dap mode.
		build_flags = "",
	},
})

require("jdtls.dap").setup_dap_main_class_configs()
