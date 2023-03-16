local nvim_test_ok, nvim_test = pcall(require, "nvim-test")
if not nvim_test_ok then
	return
end

nvim_test.setup({
	term = "toggleterm",
	silent = true,
})

local u = require("modules.utils.utils")

-- vim.g["test#strategy"] = "toggleterm"
-- vim.g["test#neovim#term_position"] = "vert"
--
u.nmap("<leader>tn", ":TestNearest<CR>") -- Test nearest test
u.nmap("<leader>tf", ":TestFile<CR>") -- Test file
u.nmap("<leader>ts", ":TestSuite<CR>") -- Test suite
u.nmap("<leader>tl", ":TestLast<CR>") -- Test last test run
u.nmap("<leader>tv", ":TestVisit<CR>") -- Test visit

--[[require("nvim-test.runners.jest"):setup({
	command = "pnpm jest", -- a command to run the test runner
	args = { "--collectCoverage=false" }, -- default arguments
	env = { CUSTOM_VAR = "value" }, -- custom environment variables

	file_pattern = "\\v(__tests__/.*|(spec|test))\\.(js|jsx|coffee|ts|tsx)$", -- determine whether a file is a testfile
	find_files = { "{name}.test.{ext}", "{name}.spec.{ext}" }, -- find testfile for a file

	filename_modifier = nil, -- modify filename before tests run (:h filename-modifiers)
	working_directory = nil, -- set working directory (cwd by default)
})
--]]
