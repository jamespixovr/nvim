local catppuccin_ok, catppuccin = pcall(require, "catppuccin")
if not catppuccin_ok then
	return
end

-- catppuccin config
local config = {
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
}
catppuccin.setup(config)
-- load the color scheme
vim.cmd([[colorscheme catppuccin]])
