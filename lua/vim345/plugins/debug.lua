return {
	{
		"mfussenegger/nvim-dap",
		lazy = false,
	},
	{
		"leoluz/nvim-dap-go",
		lazy = false,
		ft = "go",
		dependencies = {
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-notify",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap_ok, dap = pcall(require, "dap")
			if not dap_ok then
				print("nvim-dap not installed!")
				return
			end

			require("dap").set_log_level("INFO") -- Helps when configuring DAP, see logs with :DapShowLog

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

			if not (dap_ok and dap_ui_ok) then
				require("notify")("nvim-dap or dap-ui not installed!", "warning") -- nvim-notify is a separate plugin, I recommend it too!
				return
			end

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
