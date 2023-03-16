local hop_ok, hop = pcall(require, "hop")
if not hop_ok then
	return
end

local u = require("modules.utils.utils")

hop.setup({ keys = "etovxqpdygfblzhckisuran" })

u.nmap(
	"<Leader>f",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = false })<cr>"
)
u.nmap(
	"<Leader>F",
	"<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>"
)
