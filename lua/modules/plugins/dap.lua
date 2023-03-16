local dap_ok, dap = pcall(require, "dap")
if not dap_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

local u = require("modules.utils.utils")

u.nmap("<leader>ds", '<cmd> lua require("dap").continue()<CR>')
u.nmap("<leader>dc", '<cmd> lua require("dap").step_over()<CR>')
u.nmap("<leader>di", '<cmd> lua require("dap").step_into()<CR>')
u.nmap("<leader>do", '<cmd> lua require("dap").step_out()<CR>')
u.nmap("<Leader>db", '<cmd> lua require("dap").toggle_breakpoint()<CR>')
u.nmap("<Leader>dr", ':lua require("dap").repl.open()<CR>')
--[[ u.nmap("<space>dr", "<cmd> lua require(\"dap\").repl.open<CR>" )
u.nmap("<space>dl", "<cmd> lua require(\"dap\").run_last<CR>" ) ]]
--[[ vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Breakpoint" })
vim.fn.sign_define("DapStopped", { text = "", texthl = "Stopped" }) ]]
require("telescope").load_extension("dap")

dapui.setup({
	icons = { expanded = "▾", collapsed = "▸" },
	mappings = {
		-- Use a table to apply multiple mappings
		expand = { "<CR>", "<2-LeftMouse>" },
		open = "o",
		remove = "d",
		edit = "e",
		repl = "r",
		toggle = "t",
	},
	layouts = {
		{
			elements = {
				-- Elements can be strings or table with id and size keys.
				{ id = "scopes", size = 0.25 },
				"breakpoints",
				"stacks",
				"watches",
			},
			size = 40, -- 40 columns
			position = "left",
		},
		{
			elements = {
				"repl",
				"console",
			},
			size = 0.25, -- 25% of total lines
			position = "bottom",
		},
	},
	controls = {
		-- Requires Neovim nightly (or 0.8 when released)
		enabled = true,
		-- Display controls in this element
		element = "repl",
		icons = {
			pause = "",
			play = "",
			step_into = "",
			step_over = "",
			step_out = "",
			step_back = "",
			run_last = "",
			terminate = "",
		},
	},
	floating = {
		max_height = nil, -- These can be integers or a float between 0 and 1.
		max_width = nil, -- Floats will be treated as percentage of your screen.
		border = "rounded", -- Border style. Can be "single", "double" or "rounded"
		mappings = {
			close = { "q", "<Esc>" },
		},
	},
	windows = { indent = 1 },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
