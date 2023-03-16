local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

lspconfig.cucumber_language_server.setup({
	cmd = { "cucumber-language-server", "--stdio" },
	filetypes = { "cucumber", "feature" },
	--[[ settings = {
		cucumber = {
			features = { "**/*.feature" },
			glue = {
				"features/**/*.ts",
				"features/**/*.tsx",
				"features/**/*.js",
				"features/**/*.jsx",
			},
		},
	},
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(), ]]
})
