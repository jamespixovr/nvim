local u = require("modules.utils.utils")

-- local sorters = require("telescope.sorters")

TelescopeMapArgs = TelescopeMapArgs or {}

local map_tele = function(key, f, options, buffer)
	local map_key = vim.api.nvim_replace_termcodes(key .. f, true, true, true)

	TelescopeMapArgs[map_key] = options or {}

	local mode = "n"
	local rhs = string.format(
		"<cmd>lua require('modules.plugins.telescope.config')['%s'](TelescopeMapArgs['%s'])<CR>",
		f,
		map_key
	)

	local map_options = {
		noremap = true,
		silent = true,
	}

	if not buffer then
		u.map(mode, key, rhs, map_options)
	else
		u.buf_map(mode, key, rhs, map_options)
	end
end

-- generic mappings

--find * commands/mappings
u.command("Files", "Telescope find_files theme=ivy")
u.command("Rg", "Telescope live_grep theme=get_ivy")
u.command("GrepStr", "Telescope grep_string theme=ivy")
u.command("BLines", "Telescope current_buffer_fuzzy_find")
u.command("History", "Telescope oldfiles")
u.command("Buffers", "Telescope buffers")
u.command("Resume", "Telescope resume")

--git * commands
u.command("BCommits", "Telescope git_bcommits")
u.command("Commits", "Telescope git_commits")
u.command("Branchs", "Telescope git_branches")
u.command("GStatus", "Telescope git_status")

--help commands
u.command("HelpTags", "Telescope help_tags")
u.command("ManPages", "Telescope man_pages")

--- LSP Commands
u.command("LspRef", "Telescope lsp_references")
u.command("LspDef", "Telescope lsp_definitions")
u.command("LspSym", "Telescope lsp_workspace_symbols")
-- u.command("LspAct", "Telescope lsp_code_actions theme=cursor")
u.command("LspAct", "lua vim.lsp.buf.code_action()")

-- local map = vim.api.nvim_set_keymap
u.nmap("<Leader>T", ":Telescope<CR>")
u.nmap("<C-p>", "<cmd>lua require'telescope'.extensions.project.project{display_type = 'full'}<cr>")
-- u.nmap('<Leader>p', ":Telescope file_browser path='%:p:h'<cr>") --not working
-- u.nmap('<Leader>e', '<cmd>lua require\'modules.plugins.telescope.config\'.project_files({theme=ivy})<cr>')
u.nmap("<Leader>sp", "<cmd>Rg<CR>")
u.nmap("<Leader>fs", "<cmd>GrepStr<CR>")
u.nmap("<Leader>b", "<cmd>Buffers<CR>")
u.nmap("<Leader>o", "<cmd>History<CR>")
u.nmap("<Leader>rr", "<cmd>Resume<CR>")

-- lsp mappings/commands
u.nmap("<Leader>w", "<cmd>LspAct<CR>")

map_tele("<space>e", "project_files", { theme = "ivy" })
map_tele("<space>p", "file_browser")
map_tele("<space>ff", "search_only_certain_files")
map_tele("<space>fd", "fd")
map_tele("<space>dl", "Telescope diagnostics theme=ivy")
