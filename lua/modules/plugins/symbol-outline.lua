local symboloutline_ok, symboloutline = pcall(require, "symbols-outline")
if not symboloutline_ok then
	return
end

symboloutline.setup()

-- mappings
local u = require("modules.utils.utils")

u.map("n", "<leader>ss", "<cmd>SymbolsOutline<cr>")
