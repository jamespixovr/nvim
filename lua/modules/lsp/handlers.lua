local u = require("modules.utils.utils")
local M = {}
local has_ufo, ufo = pcall(require, "ufo")

M.setup = function()
	local icons = require("modules.utils.icons")
	local signs = {
		{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
		{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		-- virtual text => set to false to disable the virtual text
		virtual_text = false,
		-- show signs
		signs = {
			active = signs,
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local function lsp_highlight_document(client)
	-- if client.resolved_capabilities.document_highlight then
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
	--end
end

local show_documentation = function(bufnr)
	local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
	if filetype == "lua" then
		local line = vim.api.nvim_get_current_line()
		if vim.regex([[vim\.\([bwg]\?o\|opt\|api\)\.]]):match_str(line) then
			vim.cmd.help(vim.fn.expand("<cword>"))
			return
		end
	end

	vim.lsp.buf.hover()
end

local function lsp_keymaps(bufnr)
	-- commands
	u.lua_command("LspFormatting", "vim.lsp.buf.formatting_sync()")
	u.lua_command("LspHover", "vim.lsp.buf.hover()")
	u.lua_command("LspRename", "vim.lsp.buf.rename()")
	u.lua_command("LspDiagPrev", "vim.diagnostic.goto_prev({ popup_opts = popup_opts })")
	u.lua_command("LspDiagNext", "vim.diagnostic.goto_next({ popup_opts = popup_opts })")
	u.lua_command("LspDiagLine", 'vim.diagnostic.open_float(0, { scope="line" })')
	u.lua_command("LspSignatureHelp", "vim.lsp.buf.signature_help()")
	u.lua_command("LspTypeDef", "vim.lsp.buf.type_definition()")
	u.lua_command("LspProblem", "vim.diagnostic.open_float()")
	u.lua_command("LspDeclaration", "vim.lsp.buf.declaration()")
	u.lua_command("LspImplementation", "vim.lsp.buf.implementation()")
	u.lua_command("LspDiagList", "vim.diagnostic.setloclist()")
	u.lua_command("LspQuickFixList", "vim.diagnostic.setqflist()")
	u.lua_command("LspCodeAction", "vim.lsp.buf.code_action()")

	-- bindings
	u.buf_map("n", "<Leader>cr", ":LspRename<CR>", nil, bufnr)
	u.buf_map("n", "gy", ":LspTypeDef<CR>", nil, bufnr)
	--u.buf_map("n", "K", ":LspHover<CR>", nil, bufnr)
	local bufopts = { buffer = bufnr, silent = true }
	vim.keymap.set("n", "K", function()
		local winid
		if has_ufo then
			winid = ufo.peekFoldedLinesUnderCursor()
		end

		if not winid then
			show_documentation(bufnr)
		end
	end, bufopts)

	u.buf_map("n", "]a", ":LspDiagList<CR>", nil, bufnr)
	u.buf_map("n", "[d", ":LspDiagPrev<CR>", nil, bufnr)
	u.buf_map("n", "]d", ":LspDiagNext<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>dk", ":LspDiagPrev<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>dj", ":LspDiagNext<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>D", ":LspDiagLine<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>d", ":LspProblem<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>k", ":LspSignatureHelp<CR>", nil, bufnr)
	u.buf_map("n", "ga", ":LspCodeAction<CR>", nil, bufnr)
	u.buf_map("n", "<Leader>qf", ":LspQuickFixList<CR>", nil, bufnr)
	-- u.buf_map('i', '<C-x><C-x>', '<cmd>LspSignatureHelp<CR>', nil, bufnr)

	-- telescope
	u.buf_map("n", "gr", ":LspRef<CR>", nil, bufnr)
	u.buf_map("n", "gd", ":LspDef<CR>", nil, bufnr)
	u.buf_map("n", "gT", ":LspDef<CR>", nil, bufnr)
	u.buf_map("n", "gD", ":LspDeclaration<CR>", nil, bufnr)
	u.buf_map("n", "gi", ":LspImplementation<CR>", nil, bufnr)
	-- u.buf_map("n", "<Leader>ff", ":LspFormatting<CR>", nil, bufnr)
end

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

M.on_attach = function(client, bufnr)
	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				lsp_formatting(bufnr)
			end,
		})
	end

	vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

	lsp_keymaps(bufnr)
	lsp_highlight_document(client)
end

function M.enable_format_on_save()
	vim.cmd([[
	   augroup format_on_save
	     autocmd!
	     autocmd BufWritePre * lua vim.lsp.buf.format()
	   augroup end
	 ]])
	vim.notify("Enabled format on save")
end

function M.remove_augroup(name)
	if vim.fn.exists("#" .. name) == 1 then
		vim.cmd("au! " .. name)
	end
end

function M.common_capabilities()
	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		return cmp_nvim_lsp.default_capabilities()
	end

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}
	capabilities.window = {
		workDoneProgress = true,
	}

	if has_ufo then
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}
	end

	return capabilities
end

return M
