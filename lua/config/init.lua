---Try to require the module, and do not error out when one of them cannot be
---loaded, but do notify if there was an error.
---@param module string module to load
local function safeRequire(module)
  local success, _ = pcall(require, module)
  if success then return end
  vim.cmd.echomsg(("'Error loading %s'"):format(module))
end

local disable_providers = function()
  local default_providers = {
    --    "node",
    "perl",
    "python3",
    "ruby",
  }

  for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
  end
end

local add_filetype = function()
  vim.filetype.add({
    extension = {
      hurl = "hurl",
    },
  })
end

local leader_map = function()
  vim.api.nvim_set_keymap("n", "<Space>", "", { noremap = true })
  vim.api.nvim_set_keymap("x", "<Space>", "", { noremap = true })
  vim.g.maplocalleader = " "
  vim.g.mapleader = " "
end

local load_core = function()
  disable_providers()
  leader_map()
  add_filetype()

  safeRequire("config.lazy")

  safeRequire("config.keymaps")
  safeRequire("config.autocmds")
  safeRequire("config.options")
  safeRequire("config.commands")
end

load_core()
