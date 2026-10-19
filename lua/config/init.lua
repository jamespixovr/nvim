Helpers.safeRequire('config.options') -- early, so available for plugins configs

local disable_providers = function()
  local default_providers = {
    'node',
    'perl',
    'python3',
    'ruby',
  }

  for _, provider in ipairs(default_providers) do
    vim.g['loaded_' .. provider .. '_provider'] = 0
  end
end

local leader_map = function()
  vim.api.nvim_set_keymap('n', '<Space>', '', { noremap = true })
  vim.api.nvim_set_keymap('x', '<Space>', '', { noremap = true })
  vim.g.maplocalleader = ' '
  vim.g.mapleader = ' '
end

leader_map()

Helpers.safeRequire('config.keymaps')
Helpers.safeRequire('config.commands')
Helpers.safeRequire('config.autocmds')

disable_providers()

Helpers.safeRequire('config.lazy')

vim.api.nvim_create_autocmd('InsertEnter', {
  desc = 'User(once): Lazyload spellfixes',
  once = true,
  callback = function()
    Helpers.safeRequire('config.spellfixes')
  end,
})
