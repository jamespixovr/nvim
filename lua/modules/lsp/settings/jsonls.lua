local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

lspconfig.jsonls.setup({
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
		},
	},
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	setup = {
		commands = {
			-- Format = {
			--   function()
			--     vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line "$", 0 })
			--   end,
			-- },
		},
	},
})
