local pair_ok, npairs = pcall(require, "nvim-autopairs")
if not pair_ok then
	return
end

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string", "source" },
		javascript = { "string", "template_string" },
		java = false,
	},
	disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
	enable_check_bracket_line = false,
	fast_wrap = {
		map = "<C-h>",
		chars = { "{", "[", "(", '"', "'" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		-- pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
		-- offset = 0, -- Offset from pattern match
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		-- highlight = "PmenuSel",
		highlight_grey = "Comment",
		--  highlight_grey = "LineNr",
	},
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

-- https://github.com/windwp/nvim-autopairs
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
