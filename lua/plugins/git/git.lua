local function gitsigns_keymaps()
  return {
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview Hunk' },
    { ']g', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next Hunk' },
    { '[g', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Prev Hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage Hunk' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset Hunk' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' },
    { '<leader>ga', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle Git Blame' },
    { '<leader>hg', '<cmd>Gitsigns diffthis HEAD<cr>', desc = 'Git Diff This' },
  }
end
return {
  -- git signs
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufNewFile', 'BufReadPost', 'BufWritePre' },
    keys = gitsigns_keymaps(),
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = ' ' },
        topdelete = { text = ' ' },
        changedelete = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = false,
      diff_opts = { internal = true },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
      gh = true,
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <abbrev_sha> - <summary>',
      sign_priority = 20,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'rounded',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1,
      },
    },
  },
}
