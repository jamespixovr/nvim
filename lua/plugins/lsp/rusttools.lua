-- local rust_ok, rusttools = pcall(require, "rust-tools")
-- if not rust_ok then
-- 	return
-- end

local extension_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/")
	or vim.fn.expand("~/") .. ".vscode/extensions/vadimcn.vscode-lldb-1.8.1/"
-- local extension_path = vim.env.HOME .. "/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

if vim.fn.has("mac") == 1 then
	liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
end

local opts = {
	tools = { -- rust-tools options
		executor = require("rust-tools/executors").termopen,
		reload_workspace_from_cargo_toml = true,
		runnables = {
			use_telescope = true,
		},
		inlay_hints = {
			auto = true,
			show_parameter_hints = true,
			parameter_hints_prefix = "<-",
			other_hints_prefix = "=>",
			only_current_line = false,
			max_len_align = false,
			max_len_align_padding = 1,
			right_align = false,
			right_align_padding = 7,
			highlight = "Comment",
		},
		hover_actions = {
			auto_focus = true, --TODO: check it our
		},
	},
	-- dap = { -- move down
	-- 	adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	-- },
	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
	server = {
		-- on_attach is a callback called when the language server attachs to the buffer
		-- on_attach = function(client, bufnr)
		-- 	require("modules.lsp.handlers").on_attach(client, bufnr)
		-- 	-- Hover actions
		-- 	vim.keymap.set("n", "<leader>w", rusttools.hover_actions.hover_actions, { buffer = bufnr })
		-- 	-- Code action groups
		-- 	vim.keymap.set("n", "<leader>wa", rusttools.code_action_group.code_action_group, { buffer = bufnr })
		-- 	-- enable virtual text for rust
		-- 	vim.diagnostic.config({ virtual_text = true })
		-- end,
		-- capabilities = require("modules.lsp.handlers").common_capabilities(),
		settings = {
			-- to enable rust-analyzer settings visit:
			-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
			["rust-analyzer"] = {
				lens = {
					enable = true,
				},
				-- enable clippy on save
				checkOnSave = {
					allFeatures = true,
					command = "clippy",
				},
				cargo = {
					allFeatures = true,
					autoReload = true,
				},
			},
		},
	},
}

if vim.fn.filereadable(codelldb_path) and vim.fn.filereadable(liblldb_path) then
	opts.dap = {
		adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
	}
end

return opts
