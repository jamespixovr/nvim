local M = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				term_colors = true,
				compile = {
					compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
					suffix = "_compiled",
				},
				styles = {
					variables = { "italic" },
					operators = { "italic" },
				},
				integrations = {
					treesitter = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = { "italic" },
							hints = { "italic" },
							warnings = { "italic" },
							information = { "italic" },
						},
						underlines = {
							errors = { "underline" },
							hints = { "underline" },
							warnings = { "underline" },
							information = { "underline" },
						},
					},
					neotest = true,
					cmp = true,
					gitsigns = true,
					telescope = true,
					nvimtree = true,
					dap = true,
					which_key = false,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					dashboard = true,
					bufferline = true,
					markdown = true,
					notify = true,
					telekasten = true,
					symbols_outline = true,
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({
				"css",
				"scss",
				"javascript",
				html = { mode = "background" },
			}, { mode = "foreground" })
		end,
	},
}

return M
