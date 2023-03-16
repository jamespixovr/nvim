local util = require("lspconfig/util")

return {
	cmd = { "gopls", "serve" },
	filetypes = { "go", "gomod" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
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
}
