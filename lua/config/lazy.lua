local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = {
    { import = 'plugins.core' },
    { import = 'plugins.ai' },
    { import = 'plugins.dap' },
    { import = 'plugins.editor' },
    { import = 'plugins.ui' },
    { import = 'plugins.git' },
    { import = 'plugins.coding' },
    { import = 'plugins.snacks' },
    { import = 'plugins.notes' },
    { import = 'plugins.popup' },
    { import = 'plugins.misc' },
    { import = 'plugins.db' },
    { import = 'plugins.mini' },
    { import = 'plugins.theme' },
    { import = 'plugins.to-try' },
  },
  defaults = { lazy = true },
  install = { colorscheme = { 'catppuccin', 'habamax' } },
  checker = {
    enabled = true, -- automatically check for plugin updates
    notify = false, -- done on my own to use minimum condition for less noise
    frequency = 60 * 60 * 24 * 2, -- = 2 days
  },
  change_detection = {
    notify = false,
  },
  ui = {
    border = 'rounded',
    size = {
      width = 0.9,
      height = 0.9,
    },
    title = '💤 Lazy.nvim',
    wrap = false,
    icons = {
      cmd = '  ',
      config = '  ',
      event = '  ',
      ft = '  ',
      init = '  ',
      imports = '  ',
      keys = '  ',
      not_loaded = ' ',
      plugin = '  ',
      runtime = '  ',
      require = '  ',
      source = ' ',
      start = '',
      task = '  ',
    },
    pills = false,
    backdrop = 60,
  },
  dev = {
    path = '~/Projects/lua',
    patterns = { 'jarmex' },
  },
  -- diff = {
  --   cmd = 'diffview.nvim',
  -- },
  readme = { enabled = true },
  performance = {
    rtp = {
      -- disable unused builtin plugins from neovim
      disabled_plugins = {
        'man',
        'matchparen',
        'matchit',
        'netrw',
        'netrwPlugin',
        'gzip',
        'zip',
        'tar',
        'tarPlugin',
        'tutor',
        'rplugin',
        'health',
        'tohtml',
        'zipPlugin',
      },
    },
  },
})

-- 5s after startup, notify if there many plugin updates
vim.defer_fn(function()
  if not require('lazy.status').has_updates() then
    return
  end
  local threshold = 10
  local numberOfUpdates = tonumber(require('lazy.status').updates():match('%d+'))
  if numberOfUpdates < threshold then
    return
  end
  vim.notify(('󱧕 %s plugin updates'):format(numberOfUpdates), vim.log.levels.INFO, { title = 'Lazy' })
end, 5000)
