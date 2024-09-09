return {
  'vuki656/package-info.nvim',
  enabled = false,
  event = 'VeryLazy',
  dependencies = { 'folke/which-key.nvim', 'MunifTanjim/nui.nvim' },
  ft = { 'json' },
  opts = {
    colors = {
      -- TODO: add to catppuccin
      up_to_date = '#B1D99C', -- Text color for up to date dependency virtual text
      outdated = '#EAAC86', -- Text color for outdated dependency virtual text
    },
    autostart = true,
    hide_up_to_date = true,
    hide_unstable_versions = false,
    package_manager = 'pnpm',
  },
  keys = require('config.keymaps').package_info_keymaps(),
}
