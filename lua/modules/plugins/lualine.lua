-- https://github.com/hoob3rt/lualine.nvim
local lualine_ok, lualine = pcall(require, "lualine")
if not lualine_ok then
	return
end

local gps_ok, gps = pcall(require, "nvim-gps")
if not gps_ok then
	return
end

local theme = require("lualine.themes.catppuccin")
theme.normal.c.bg = require("lualine.utils.utils").extract_highlight_colors("Normal", "bg")
-- options = {section_separators = '', component_separators = ''}

local extensions = { "quickfix", "nvim-tree" }
local mode = {
	function()
		return " 󰀘  "
	end,
	padding = { left = 0, right = 0 },
	color = {},
	cond = nil,
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = require("modules.utils.statusline").theme(), -- "catppuccin",
		--		section_separators = { left = "", right = "" },
		--		section_separators = { left = '', right = ''},
		section_separators = { left = "", right = "" },
		component_separators = "",
		globalstatus = true,
		always_divide_middle = true,
		disabled_filetypes = { "alpha" },
	},
	sections = {
		-- lualine_a = { { "mode", separator = { left = "", right = "" } } },
		lualine_a = { mode },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { gps.get_location, cond = gps.is_available } },
		-- lualine_c = { { "filename" }, { gps.get_location, cond = gps.is_available } },
		lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		-- lualine_z = { { "location", separator = { left = "", right = "" } } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	extensions = extensions,
})
--[[
local colors = {
    foreground = "#FFFFFF",
    background = "#007ACC",
    header_background = "#2C896B",
}

local component_colors = {
    a = { fg = colors.foreground, bg = colors.header_background },
    b = { fg = colors.foreground, bg = colors.background },
    c = { fg = colors.foreground, bg = colors.background },

    x = { fg = colors.foreground, bg = colors.background },
    y = { fg = colors.foreground, bg = colors.background },
    z = { fg = colors.foreground, bg = colors.background },
}

return {
    normal = component_colors,
    insert = component_colors,
    visual = component_colors,
    replace = component_colors,
    command = component_colors,
    inactive = component_colors,
}
---@diagnostic disable: unused-local
return function(conf, colors)
	return {
		lualine_a = {
			{
				"headers",
				fmt = function(content, context)
					return "  "
				end,
			},
		},
		lualine_b = {
			{ "branch", icon = "" },
			{
				"mode",
				fmt = function(content, context)
					return ("-- %s --"):format(content)
				end,
			},
		},
		lualine_c = {
			{
				"filename",
				symbols = {
					modified = "",
					readonly = "",
					unnamed = "",
					newfile = "",
				},
			},
		},
		lualine_x = {
			{
				"space_style",
				fmt = function(content, context)
					local expand = vim.opt_local.expandtab:get()
					local widht = vim.opt_local.shiftwidth:get()
					local style = expand and "Spaces" or "Tab Size"
					return ("%s: %s"):format(style, widht)
				end,
			},
			"encoding",
			{
				"fileformat",
				icons_enabled = false,
				fmt = function(content, context)
					local style = {
						mac = "LF",
						unix = "LF",
						dos = "CRLF",
					}
					return style[content]
				end,
			},
		},
		lualine_y = {
			{ "location", padding = { left = 0, right = 1 } },
			{ "progress" },
		},
		lualine_z = {
			{
				"filetype",
				icons_enabled = false,
			},
			{
				"decorate",
				fmt = function(content, context)
					return "   "
				end,
			},
		},
	}
end
]]
--
