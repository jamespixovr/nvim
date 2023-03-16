local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

local util = require("lspconfig/util")

lspconfig.gopls.setup({
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	on_attach = function(client, bufnr)
		require("modules.lsp.handlers").on_attach(client, bufnr)
		local _, _ = pcall(vim.lsp.codelens.refresh)
	end,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	settings = {
		gopls = {
			usePlaceholders = true,
			gofumpt = true,
			codelenses = {
				generate = false,
				gc_details = true,
				test = true,
				tidy = true,
			},
			analyses = {
				unusedparams = true,
			},
			staticcheck = true,
		},
	},
})

------------------------
-- Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
	return
end

dapgo.setup()
