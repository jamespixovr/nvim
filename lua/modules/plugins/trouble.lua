-- https://github.com/folke/trouble.nvim
local trouble_status_ok, trouble = pcall(require, "trouble")
if not trouble_status_ok then
	return
end

trouble.setup({
	-- "lsp_workspace_diagnostics",
	-- "lsp_document_diagnostics",
	-- "quickfix",
	-- "lsp_references",
	-- "loclist"
	mode = "document_diagnostics",
})

-- mappings
local u = require("modules.utils.utils")

u.map("n", "<leader>xx", "<cmd>Trouble<cr>")
u.map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")
u.map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>")
u.map("n", "<leader>xl", "<cmd>Trouble loclist<cr>")
u.map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>")
u.map("n", "<leader>xR", "<cmd>Trouble lsp_references<cr>")
u.map("n", "gR", "<cmd>Trouble lsp_references<cr>")
