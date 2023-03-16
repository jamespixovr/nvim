local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

lspconfig.lua_ls.setup({
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	settings = {
		Lua = {
			completion = { enable = true, showWord = "Disable", callSnippet = "Replace" },
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
