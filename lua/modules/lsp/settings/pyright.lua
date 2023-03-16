local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

lspconfig.pyright.setup({
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "off",
			},
		},
	},
})
