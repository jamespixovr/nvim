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
  keys = {
    { '<leader>pi', "<cmd>lua require('package-info').show()<cr>", desc = 'Package Info' },
    { '<leader>pd', "<cmd>lua require('package-info').delete()<cr>", desc = 'Delete Package' },
    { '<leader>pu', "<cmd>lua require('package-info').update()<cr>", desc = 'Update Package' },
    { '<leader>pU', "<cmd>lua require('package-info').update_all()<cr>", desc = 'Update All Packages' },
    { '<leader>pc', "<cmd>lua require('package-info').change_version()<cr>", desc = 'Change Package Version' },
    { '<leader>pi', "<cmd>lua require('package-info').install()<cr>", desc = 'Install Package' },
  },
}
