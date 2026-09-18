return {
  {
    'NeogitOrg/neogit',
    version = '*',
    event = 'VeryLazy',
    dependencies = {
      'esmuellert/codediff.nvim', -- optional - Diff integration
      'nvim-lua/plenary.nvim',
      'folke/snacks.nvim',
    },
    cmd = 'Neogit',
    opts = {
      kind = 'floating',
      floating = {
        relative = 'editor',
        width = 0.85,
        height = 0.8,
        style = 'minimal',
        border = 'rounded',
      },
      commit_view = {
        kind = 'split',
        verify_commit = vim.fn.executable('gpg') == 1,
      },
      auto_show_console = false,
      auto_close_console = true,
      console_timeout = 10000,
      disable_context_highlighting = false,
      disable_signs = false,
      disable_hint = false,
      commit_select_view = { kind = 'tab' },
      log_view = { kind = 'tab' },
      reflog_view = { kind = 'tab' },
      rebase_editor = { kind = 'auto' },
      filewatcher = { interval = 2000, enabled = true },
      disable_insert_on_commit = true,
      fetch_after_checkout = false,
      graph_style = 'unicode',
      process_spinner = false,
      commit_editor = {
        kind = 'tab',
        show_staged_diff = true,
        staged_diff_split_kind = 'vsplit',
        spell_check = true,
      },
      remember_settings = true,
      use_per_project_settings = true,
      integrations = {
        snacks = true,
        diffview = false,
        telescope = false,
        codediff = true,
      },
      diff_viewer = 'codediff',
      status = {
        show_head_commit_hash = true,
        recent_commit_count = 10,
        HEAD_padding = 10,
        HEAD_folded = false,
        mode_padding = 3,
      },
      sort_branches = '-committerdate',

      commit_order = 'topo',

      disable_line_numbers = true,
      disable_relative_line_numbers = true,

      sections = {
        stashes = {
          folded = true,
          hidden = false,
        },
        unpulled_upstream = {
          folded = true,
          hidden = false,
        },
        recent = {
          folded = true,
          hidden = false,
        },
        rebase = {
          folded = false,
          hidden = false,
        },
      },
    },
    keys = {
      { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
    },
    config = true,
  },
}
