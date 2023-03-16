local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

lspconfig.yamlls.setup({
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	settings = {
		yaml = {
			hover = true,
			completion = true,
			validate = true,
			-- other settings. note this overrides the lspconfig defaults.
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["../path/relative/to/file.yml"] = "/.github/workflows/*",
				["/path/from/root/of/project"] = "/.github/workflows/*",
			},
		},
	},
})
