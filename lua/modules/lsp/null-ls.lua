local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local b = null_ls.builtins
-- local utils = require("null-ls.utils").make_conditional_utils()

local function preferedEslint(utils)
	return utils.root_has_file({ ".eslintrc", ".eslintrc.yml", ".eslintrc.yaml", ".eslintrc.js", "eslintrc.json" })
end

local command_resolver = require("null-ls.helpers.command_resolver")

local prettier = b.formatting.prettier.with({
	dynamic_command = command_resolver.from_node_modules(),
})

local sources = {
	-- code action
	b.code_actions.refactoring,
	-- diagnostics
	b.diagnostics.yamllint.with({ extra_filetypes = { "yml" } }), -- add support for yml extensions
	b.diagnostics.eslint.with({
		prefer_local = "node_modules/.bin",
		condition = function(utils)
			return preferedEslint(utils)
		end,
	}),
	b.diagnostics.tidy, -- xml
	-- formatting
	prettier,
	b.formatting.tidy,
	-- b.formatting.prettierd.with({
	-- 	extra_filetypes = { "yml", "toml", "solidity" },
	-- 	extra_args = { "--single-quote", "--jsx-single-quote", "--print-width 80", "--trailing-comma es5" },
	-- }),
	b.formatting.stylua,
	b.formatting.rustfmt, -- rust
	-- b.formatting.google_java_format, --java
	-- b.formatting.black.with({ extra_args = { "--fast" } }), --python
	-- SQL
	b.diagnostics.sqlfluff.with({
		extra_args = { "--dialect", "postgres" },
	}),
	b.formatting.sqlfluff.with({
		extra_args = { "--dialect", "postgres" },
	}),
	-- b.formatting.pg_format,
	-- b.formatting.sql_formatter,
	--b.formatting.jq, --json
	-- PROTO
	b.formatting.buf,
	b.diagnostics.buf,
	--
	-- GOLANG
	b.formatting.gofumpt,
	b.formatting.goimports,
	-- b.diagnostics.revive, -- this is causing problems, underline on all the functions
	b.diagnostics.golangci_lint,
	b.diagnostics.staticcheck,
	--
	-- .ENV
	b.diagnostics.dotenv_linter,
	-- Dockerfile
	b.diagnostics.hadolint, -- dockerfile
	--todo_comments
	b.diagnostics.todo_comments,
	-- typescript nvim
	require("typescript.extensions.null-ls.code-actions"),
	b.code_actions.eslint.with({
		prefer_local = "node_modules/.bin",
		condition = function(utils)
			return preferedEslint(utils)
		end,
	}),
}

null_ls.setup({
	debug = false,
	-- on_attach = on_attach,
	sources = sources,
	on_attach = require("modules.lsp.handlers").on_attach,
})
