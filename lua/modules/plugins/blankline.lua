-- https://github.com/lukas-reineke/indent-blankline.nvim

local cmd = vim.cmd

--vim.opt.list = true
-- vim.opt.listchars:append("space:⋅")
-- vim.opt.listchars:append("eol:↴")
vim.opt.termguicolors = true
vim.wo.colorcolumn = "99999"

require("indent_blankline").setup({
	-- char = "|",
	use_treesitter = true,
	space_char_blankline = " ",
	show_current_context = true,
	-- How to remove the underlining of the line
	show_current_context_start = false,
	show_trailing_blankline_indent = false,
	-- for deciding if end of line characters are overwritten with indent lines or not
	show_end_of_line = false,
	show_first_indent_level = false,
	max_indent_increase = 1,
	context_patterns = {
		"class",
		"return",
		"function",
		"method",
		"^if",
		"^do",
		"^switch",
		"^while",
		"jsx_element",
		"^for",
		"^object",
		"^table",
		"block",
		"arguments",
		"if_statement",
		"else_clause",
		"jsx_element",
		"jsx_self_closing_element",
		"try_statement",
		"catch_clause",
		"import_statement",
		"operation_type",
	},
	filetype_exclude = {
		"help",
		"startify",
		"dashboard",
		"packer",
		"neogitstatus",
		"NvimTree",
		"Trouble",
		"terminal",
	},
})

-- cmd([[ hi IndentBlanklineChar guifg=#aaaaaa ]])
cmd([[ highlight IndentBlanklineContextChar guifg=#FF7F7F gui=nocombine ]])
