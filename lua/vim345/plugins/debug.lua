local home = os.getenv("HOME")
local keymap = vim.keymap -- for conciseness

local function ensure_debugpy_installed()
	local handle = io.popen('python -c "import debugpy" 2>/dev/null && echo 1 || echo 0')
	local result = handle:read("*a")
	handle:close()

	if result:match("0") then
		print("debugpy not found, installing...")
		os.execute("python -m pip install debugpy")
	else
		print("debugpy is already installed")
	end
end

local function enable_debugger(bufnr)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })

	local opts = { buffer = bufnr }
	-- vim.keymap.set("n", "<leader>dnc", "<cmd>lua require('jdtls').test_class()<cr>", opts)
	-- vim.keymap.set("n", "<leader>dnt", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
	vim.keymap.set("n", "<F2>", "<cmd>lua require('jdtls.dap').setup_dap_main_class_configs()<CR>", opts)
end

local function jdtls_on_attach(_, bufnr)
	on_attach()
	enable_debugger(bufnr)
end

local dap_common = function()
	local dap_ok, dap = pcall(require, "dap")
	if not dap_ok then
		print("nvim-dap not installed!")
		return
	end

	require("dap").set_log_level("INFO") -- Helps when configuring DAP, see logs with :DapShowLog
	local dap_ui_ok, ui = pcall(require, "dapui")
	if not (dap_ok and dap_ui_ok) then
		require("notify")("nvim-dap or dap-ui not installed!", "warning") -- nvim-notify is a separate plugin, I recommend it too!
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
			{
				elements = {
					"repl",
					"breakpoints",
				},
				size = 0.3,
				position = "bottom",
			},
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

	vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

	-- Start debugging session
	vim.keymap.set("n", "<F5>", function()
		dap.continue()
		ui.toggle({})
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
	end)

	-- Set breakpoints, get variable values, step into/out of functions, etc.
	vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
	vim.keymap.set("n", "<localleader>dc", "<cmd>DapContinue<CR>")
	vim.keymap.set("n", "<localleader>db", "<cmd>DapToggleBreakpoint<CR>")
	vim.keymap.set("n", "<localleader>dn", "<cmd>DapStepOver<CR>")
	vim.keymap.set("n", "<localleader>di", "<cmd>DapStepInto<CR>")
	vim.keymap.set("n", "<localleader>do", "<cmd>DapStepOut<CR>")
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

	-- Eval var under cursor
	vim.keymap.set("n", "<localleader>d?", function()
		require("dapui").eval(nil, { enter = true })
	end)

	vim.api.nvim_set_keymap("n", "<F6>", '<Cmd>lua require"dap".run_last()<CR>', { noremap = true, silent = true })

	dap.listeners.before.attach.dapui_config = function()
		ui.open()
	end
	dap.listeners.before.launch.dapui_config = function()
		ui.open()
	end
	dap.listeners.before.event_terminated.dapui_config = function()
		ui.close()
	end
	dap.listeners.before.event_exited.dapui_config = function()
		ui.close()
	end
end
return {
	{
		"mfussenegger/nvim-dap",
		"theHamsta/nvim-dap-virtual-text",
		config = function() end,
		lazy = false,
	},
	{
		"mfussenegger/nvim-dap-python",
		lazy = true,
		ft = "python",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-notify",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			dap_common()
			local dap_python = require("dap-python")
			-- Ensure debugpy is installed in the current virtual environment
			ensure_debugpy_installed()
			dap_python.test_runner = "pytest"
			dap_python.setup("python")
			keymap.set("n", "<leader>tc", function()
				if vim.bo.filetype == "python" then
					require("dap-python").test_class()
				end
			end)

			keymap.set("n", "<leader>tm", function()
				if vim.bo.filetype == "python" then
					require("dap-python").test_method()
				end
			end)

			keymap.set("n", "<leader>ts", function()
				if vim.bo.filetype == "python" then
					require("dap-python").debug_selection()
				end
			end)
		end,
	},
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
		config = function()
			dap_common()
			jdtls_on_attach()
		end,
	},
	{
		"leoluz/nvim-dap-go",
		lazy = true,
		ft = "go",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-notify",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			dap_common()
			local dap_ok, dap = pcall(require, "dap")
			if not dap_ok then
				print("nvim-dap not installed!")
				return
			end
			dap.configurations = {
				go = {
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
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		config = function()
			local mason_nvim_dap = require("mason-nvim-dap")
			mason_nvim_dap.setup({
				ensure_installed = {
					"python",
					"delve",
					"jq",
				},
				automatic_installation = true,
			})
		end,
	},
}
