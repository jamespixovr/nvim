
local refactoring_ok, refactoring = pcall(require, "refactoring")
if not refactoring_ok then
  return
end

refactoring.setup({})

-- load refactoring Telescope extension
require("telescope").load_extension("refactoring")

local u = require('modules.utils.utils')
u.map("v","<leader>rr", "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>" )
