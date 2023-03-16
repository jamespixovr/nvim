local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

mason.setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

local status_ok, lsp_installer = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

lsp_installer.setup({
	ensure_installed = { "rust_analyzer", "lua_ls", "tsserver", "gopls", "yamlls", "jsonls", "emmet_ls" }, -- ensure these servers are always installed
	automatic_installation = { exclude = { "cucumber_language_server" } }, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
})
require("modules.lsp.rusttools")
require("modules.lsp.settings.jsonls")
require("modules.lsp.settings.yamlls")
require("modules.lsp.settings.tsserver")
require("modules.lsp.settings.sumneko_lua")
require("modules.lsp.settings.pyright")
require("modules.lsp.settings.emmet_ls")
require("modules.lsp.settings.gopls")
require("modules.lsp.settings.cucumber")
--jdt.ls is setup differently
