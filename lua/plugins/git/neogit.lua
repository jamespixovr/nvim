return {
  {
    'NeogitOrg/neogit',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'nvim-telescope/telescope.nvim',
    },
    cmd = 'Neogit',
    opts = {
      integrations = { diffview = true },
      kind = 'tab',
      auto_show_console = true,
      status = { recent_commit_count = 10 },
      commit_editor = { kind = 'split' },
      commit_select_view = { kind = 'tab' },
      log_view = { kind = 'tab' },
      rebase_editor = { kind = 'split' },
    },
    keys = {
      { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
    config = true,
  },
}
