return {
  {
    'saxon1964/neovim-tips',
    enabled = true,
    version = '*', -- Only update on tagged releases
    cmd = { 'NeovimTips', 'NeovimTipsEdit', 'NeovimTipsAdd', 'NeovimTipsRandom' },
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- 'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      -- OPTIONAL: Location of user defined tips (default value shown below)
      user_file = vim.fn.stdpath('config') .. '/neovim_tips/user_tips.md',
      -- OPTIONAL: Prefix for user tips to avoid conflicts (default: "[User] ")
      user_tip_prefix = '[User] ',
      -- OPTIONAL: Show warnings when user tips conflict with builtin (default: true)
      warn_on_conflicts = true,
      -- OPTIONAL: Daily tip mode (default: 1)
      -- 0 = off, 1 = once per day, 2 = every startup
      daily_tip = 0,
    },
  },
  -- {
  --   'alex-popov-tech/store.nvim',
  --   dependencies = { 'OXY2DEV/markview.nvim' },
  --   cmd = 'Store',
  -- },
}
