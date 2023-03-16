local action_state = require("telescope.actions.state")
local themes = require("telescope.themes")

local M = {}

function M.project_files()
	local opts = {} -- with_preview
	--local opts = vim.deepcopy(options)
	opts.prompt_prefix = "~> "
	opts.theme = "ivy"
	vim.fn.system("git rev-parse --is-inside-work-tree")
	if vim.v.shell_error == 0 then
		require("telescope.builtin").git_files(opts)
	else
		require("telescope.builtin").find_files(opts)
	end
end

--- https://github.com/tjdevries/config_manager/blob/8f14ab2dd6ba40645af196cc40116b55c0aca3c0/xdg_config/nvim/lua/tj/telescope/init.lua
function M.search_only_certain_files()
	require("telescope.builtin").find_files({
		theme = "ivy",
		-- find_command = {"fd", "--type", "f", "--strip-cwd-prefix"},
		find_command = {
			"rg",
			"--files",
			"--type",
			vim.fn.input("Type: "),
		},
	})
end

function M.lsp_references()
	require("telescope.builtin").lsp_references({
		layout_strategy = "vertical",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

function M.lsp_implementations()
	require("telescope.builtin").lsp_implementations({
		layout_strategy = "vertical",
		layout_config = {
			prompt_position = "top",
		},
		sorting_strategy = "ascending",
		ignore_filename = false,
	})
end

function M.file_browser()
	local opts

	opts = {
		sorting_strategy = "ascending",
		scroll_strategy = "cycle",
		layout_config = {
			prompt_position = "top",
		},
		theme = "ivy",
		attach_mappings = function(prompt_bufnr, map)
			local current_picker = action_state.get_current_picker(prompt_bufnr)

			local modify_cwd = function(new_cwd)
				local finder = current_picker.finder

				finder.path = new_cwd
				finder.files = true
				current_picker:refresh(false, { reset_prompt = true })
			end

			map("i", "-", function()
				modify_cwd(current_picker.cwd .. "/..")
			end)

			map("i", "~", function()
				modify_cwd(vim.fn.expand("~"))
			end)

			map("n", "yy", function()
				local entry = action_state.get_selected_entry()
				vim.fn.setreg("+", entry.value)
			end)

			return true
		end,
	}

	require("telescope").extensions.file_browser.file_browser(opts)
end

function M.help_tags()
	require("telescope.builtin").help_tags({
		show_version = true,
	})
end

function M.search_all_files()
	require("telescope.builtin").find_files({
		find_command = { "rg", "--no-ignore", "--files" },
	})
end

function M.project_search()
	require("telescope.builtin").find_files({
		previewer = false,
		layout_strategy = "vertical",
		cwd = require("nvim_lsp.util").root_pattern(".git")(vim.fn.expand("%:p")),
	})
end

function M.grep_last_search(opts)
	opts = opts or {}
	-- \<getreg\>\C
	-- -> Subs out the search things
	local register = vim.fn.getreg("/"):gsub("\\<", ""):gsub("\\>", ""):gsub("\\C", "")

	opts.path_display = { "shorten" }
	opts.word_match = "-w"
	opts.search = register

	require("telescope.builtin").grep_string(opts)
end

function M.live_grep()
	require("telescope.builtin").live_grep({
		-- shorten_path = true,
		previewer = false,
		fzf_separator = "|>",
	})
end

function M.grep_prompt()
	require("telescope.builtin").grep_string({
		path_display = { "shorten" },
		search = vim.fn.input("Grep String > "),
	})
end

function M.fd()
	local opts = themes.get_ivy({ hidden = false, sorting_strategy = "ascending" })
	require("telescope.builtin").fd(opts)
end

return M
