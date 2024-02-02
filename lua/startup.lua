---Try to require the module, and do not error out when one of them cannot be
---loaded, but do notify if there was an error.
---@param module string module to load
local function safeRequire(module)
  local success, _ = pcall(require, module)
  if success then return end
  vim.cmd.echomsg(("'Error loading %s'"):format(module))
end

--------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = ","
--------------------------------------------------------------------------------


safeRequire("config.lazy")

safeRequire("config.keymaps")
safeRequire("config.autocmds")
safeRequire("config.options")
safeRequire("config.commands")
