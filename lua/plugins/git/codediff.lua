return {
  {
    'esmuellert/codediff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
    opts = {
      highlights = {
        line_insert = 'DiffAdd',
        line_delete = 'DiffDelete',

        char_insert = nil,
        char_delete = nil,
      },
      -- Diff view behavior
      diff = {
        disable_inlay_hints = true,
        max_computation_time_ms = 5000,
      },

      -- Explorer panel configuration
      explorer = {
        view_mode = 'tree',
        file_filter = {
          ignore = { '*.pb.go' },
        },
      },
      -- Keymaps in diff view
      keymaps = {
        view = {
          next_hunk = ']c',
          prev_hunk = '[c',
          next_file = ']f',
          prev_file = '[f',
        },
        explorer = {
          select = '<CR>',
          hover = 'K',
          refresh = 'R',
        },
      },
    },
    keys = {
      { '<leader>gd', '<cmd>CodeDiff<cr>', desc = 'Diff file explorer' },
      { '<leader>ge', '<cmd>CodeDiff file HEAD~1<cr>', desc = 'Diff with HEAD' },
      { '<leader>gi', ':CodeDiff history HEAD~20 %<cr>', desc = 'Git File History', silent = false },
      { '<leader>gh', ':CodeDiff history<cr>', desc = 'Git History', silent = false },
    },
  },
}
