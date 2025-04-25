local function gitsigns_keymaps()
  return {
    -- { '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle Git Blame' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview Hunk' },
    { ']g', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next Hunk' },
    { '[g', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Prev Hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage Hunk' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset Hunk' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' },
    { '<leader>ga', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle Git Blame' },
    { '<leader>hg', '<cmd>Gitsigns diffthis ~<cr>', desc = 'Git Diff This' },
  }
end
return {
  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPost', 'BufWritePre' },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = gitsigns_keymaps(),
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '契' },
        topdelete = { text = '契' },
        changedelete = { text = '▎' },
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      diff_opts = { internal = true },
      current_line_blame_opts = { delay = 500 },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <abbrev_sha> - <summary>',
    },
  },
}
