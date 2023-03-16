local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end
-- https://github.com/pedro757/emmet
-- npm i -g ls_emmet
lspconfig.emmet_ls.setup({
	on_attach = require("modules.lsp.handlers").on_attach,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	-- cmd = { "emmet_ls", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"haml",
		"xsl",
		"pug",
		"slim",
		"sass",
		"stylus",
		"less",
		"sss",
		"hbs",
		"handlebars",
	},
})
