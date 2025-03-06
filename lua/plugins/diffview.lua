return {

  -- better diffing
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  event = 'VeryLazy',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles', 'DiffviewFocusFiles' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Diff View' },
    { '<leader>gt', '<cmd>DiffviewToggleFiles<cr>', desc = 'Diff View Toggle Files' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff View File History' },
    { '<leader>gL', '<cmd>.DiffviewFileHistory --follow<CR>', mode = { 'n' }, desc = 'Line history' },
    { '<leader>gH', "<esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { 'v' }, desc = 'Range history' },
    { '<leader>gF', '<cmd>DiffviewFileHistory --follow %<cr>', mode = { 'n' }, desc = 'File history' },
  },
  -- adopted from https://github.com/rafi/vim-config/blob/master/lua/rafi/plugins/git.lua
  opts = function()
    local actions = require('diffview.actions')
    vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
      group = vim.api.nvim_create_augroup('rafi_diffview', {}),
      pattern = 'diffview:///panels/*',
      callback = function()
        vim.opt_local.cursorline = true
        vim.opt_local.winhighlight = 'CursorLine:WildMenu'
      end,
    })

    return {
      enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
      keymaps = {
        -- stylua: ignore start
        view = {
          { 'n', 'q', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<esc>', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<c-n>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<c-p>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', '<c-c>', actions.toggle_files, { desc = 'Toggle the file panel' } },
          { 'n', '-', actions.toggle_stage_entry, { desc = 'Stage / unstage the selected entry' } },
          { 'n', 'gd', function() actions.goto_file_edit() vim.lsp.buf.definition() end, },
        },
        -- stylua: ignore end
        file_panel = {
          { 'n', 'q', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<esc>', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<c-n>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<c-p>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', 'X', actions.restore_entry, { desc = 'Restore entry to the state on the left side.' } },
          { 'n', '<cr>', actions.goto_file, { desc = 'Open the file in a new split in the previous tabpage' } },
          { 'n', 'i', actions.listing_style, { desc = "Toggle between 'list' and 'tree' views" } },
          { 'n', 'R', actions.refresh_files, { desc = 'Update stats and entries in the file list.' } },
          { 'n', '<c-c>', actions.toggle_files, { desc = 'Toggle the file panel' } },
          { 'n', '[x', actions.prev_conflict, { desc = 'Go to the previous conflict' } },
          { 'n', ']x', actions.next_conflict, { desc = 'Go to the next conflict' } },
        },
        file_history_panel = {
          { 'n', 'q', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<esc>', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<c-n>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<c-p>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', '<cr>', actions.goto_file, { desc = 'Open the file in a new split in the previous tabpage' } },
          { 'n', '<c-c>', actions.toggle_files, { desc = 'Toggle the file panel' } },
        },
      },
    }
  end,
}
