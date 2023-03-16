local nvim_test_ok, neotest = pcall(require, "neotest")
if not nvim_test_ok then
	return
end

local neotest_ns = vim.api.nvim_create_namespace("neotest")
vim.diagnostic.config({
	virtual_text = {
		format = function(diagnostic)
			local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
			return message
		end,
	},
}, neotest_ns)

neotest.setup({
	quickfix = {
		enabled = true,
		open = false,
	},
	adapters = {
		require("neotest-go")({
			experimental = {
				test_table = true,
			},
			-- args = { "-count=1", "-timeout=60s" }
		}),
		require("neotest-jest")({
			jestCommand = "pnpm test --",
			jestConfigFile = "custom.jest.config.ts",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
		require("neotest-rust"),
	},
	icons = {
		running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	},
})

local u = require("modules.utils.utils")

-- vim.g["test#strategy"] = "toggleterm"
-- vim.g["test#neovim#term_position"] = "vert"
--
u.nmap("<leader>tn", ":lua require('neotest').run.run()<CR>") -- Test nearest test
u.nmap("<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', {})
u.nmap("<leader>td", ":lua require('neotest').run.run({strategy = 'dap'})<CR>")
u.nmap("<leader>ta", '<cmd>lua require("neotest").run.attach()<cr>', {})
u.nmap("<leader>te", '<cmd>lua require("neotest").run.stop()<cr>', {})

-- test run output
u.nmap("<leader>ts", ":lua require('neotest').summary.toggle()<CR>") -- Test nearest test
u.nmap("<leader>to", ":lua require('neotest').output.open({ enter = true })<CR>") -- Test nearest test
u.nmap("<leader>tp", ":lua require('neotest').output_panel.toggle()<CR>") -- Test nearest test
u.nmap("<leader>tl", ":lua require('neotest').run.run_last()<CR>") -- Test last run
-- u.nmap("<leader>ts", ":TestSuite<CR>") -- Test suite
-- u.nmap("<leader>tl", ":TestLast<CR>") -- Test last test run
-- u.nmap("<leader>tv", ":TestVisit<CR>") -- Test visit
-- ONLY for JEST
u.nmap("<leader>tw", "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>")
