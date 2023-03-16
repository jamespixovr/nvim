-- https://github.com/nvim-telescope/telescope.nvim

-- adding trouble for telescope: https://github.com/folke/trouble.nvim
local actions = require("telescope.actions")

local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
	return
end

local fb_actions = require("telescope").extensions.file_browser.actions

telescope.setup({
	extensions = {
		file_browser = {
			theme = "ivy",
			path = "%:p:h",
			cwd_to_path = true,
			path_display = { truncate = 3 },
			mappings = {
				["n"] = {
					["<C-a>"] = fb_actions.create,
				},
			},
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		},
		["ui-select"] = {
			require("telescope.themes").get_cursor({
				-- even more opts
			}),
		},
	},
	defaults = {
		prompt_prefix = "~> ",
		selection_caret = "❯ ",
		layout_strategy = "horizontal",
		layout_config = {
			width = 0.95,
			height = 0.85,
			-- preview_cutoff = 120,
			prompt_position = "top",

			horizontal = {
				preview_width = function(_, cols, _)
					if cols > 200 then
						return math.floor(cols * 0.4)
					else
						return math.floor(cols * 0.6)
					end
				end,
			},

			vertical = {
				width = 0.9,
				height = 0.95,
				preview_height = 0.5,
			},

			flex = {
				horizontal = {
					preview_width = 0.9,
				},
			},
		},
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		scroll_strategy = "cycle",
		color_devicons = true,
		-- sorting_strategy = 'ascending',
		mappings = {
			i = {
				["<ESC>"] = actions.close,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,
			},
			n = {
				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,
			},
		},
	},
	pickers = {
		-- Your special builtin config goes in here
		buffers = {
			ignore_current_buffer = true,
			sort_lastused = true,
			theme = "ivy",
			previewer = false,
			mappings = {
				i = {
					["<c-d>"] = require("telescope.actions").delete_buffer,
					-- Right hand side can also be the name of the action as a string
				},
				n = {
					["<c-d>"] = require("telescope.actions").delete_buffer,
				},
			},
		},
		git_files = {
			theme = "ivy",
		},
		find_files = {
			theme = "ivy",
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
		},
		live_grep = {
			theme = "ivy",
			-- @usage don't include the filename in the search results
			only_sort_text = true,
		},
	},
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("project")
telescope.load_extension("ui-select")

_ = pcall(require, "modules.plugins.telescope.config")
_ = pcall(require, "modules.plugins.telescope.mapping")
