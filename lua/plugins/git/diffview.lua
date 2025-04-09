return {
  -- {
  --    'folke/which-key.nvim',
  --    optional = true,
  --    opts = {
  --      spec = {
  --        { '<leader>gd', group = 'diffview' },
  --      },
  --    },
  --  },

  -- better diffing
  'sindrets/diffview.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neotest/nvim-nio',
  },
  event = 'VeryLazy',
  cmd = {
    'DiffviewOpen',
    'DiffviewClose',
    'DiffviewFileHistory',
    'DiffviewToggleFiles',
    'DiffviewFocusFiles',
    'DiffviewOriginDevelopHead',
    'DiffviewRangeFileHistory',
    'DiffviewLog',
  },
  keys = {
    { '<leader>gdo', '<cmd>DiffviewOpen<cr>', desc = 'Diff View' },
    { '<leader>gdt', '<cmd>DiffviewToggleFiles<cr>', desc = 'Diff View Toggle Files' },
    { '<leader>gdh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Diff View File History' },
    -- { '<leader>gL', '<cmd>.DiffviewFileHistory --follow<CR>', mode = { 'n' }, desc = 'Line history' },
    { '<leader>gdH', "<esc><cmd>'<,'>DiffviewFileHistory --follow<CR>", mode = { 'v' }, desc = 'Range history' },
    -- { '<leader>gdF', '<cmd>DiffviewFileHistory --follow %<cr>', mode = { 'n' }, desc = 'File history' },
    {
      '<leader>gdg',
      '<cmd>DiffviewOpen<cr>',
      mode = { 'n', 'v' },
      desc = 'Diffview Open',
    },
    {
      '<leader>gdF',
      '<cmd>0,$DiffviewFileHistory --follow<cr>',
      mode = { 'n' },
      desc = 'Diffview Range File History',
    },
    {
      '<leader>gdf',
      '<cmd>DiffviewFileHistory --no-merges --follow %<cr>',
      mode = { 'n' },
      desc = 'Diffview File History',
    },
    {
      '<leader>gdf',
      ':DiffviewFileHistory --no-merges --follow<cr>',
      mode = { 'v' },
      desc = 'Diffview File History',
    },
    {
      '<leader>gdd',
      '<cmd>DiffviewOpen --imply-local origin/develop...HEAD<cr>',
      mode = { 'n', 'v' },
      desc = 'Diffview origin/develop...HEAD',
    },
    {
      '<leader>gdw',
      '<cmd>windo diffthis<cr>',
      mode = { 'n' },
      desc = 'Windo diffthis',
    },
    {
      '<leader>gdo',
      '<cmd>diffthis<cr>',
      mode = { 'n', 'v' },
      desc = 'diffthis',
    },
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
          { 'n', '<leader>b', false },
        },
        file_history_panel = {
          { 'n', 'q', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<esc>', ':DiffviewClose<cr>', { desc = 'Close Panel' } },
          { 'n', '<c-n>', actions.select_next_entry, { desc = 'Open the diff for the next file' } },
          { 'n', '<c-p>', actions.select_prev_entry, { desc = 'Open the diff for the previous file' } },
          { 'n', '<cr>', actions.goto_file, { desc = 'Open the file in a new split in the previous tabpage' } },
          { 'n', '<c-c>', actions.toggle_files, { desc = 'Toggle the file panel' } },
          { 'n', '<leader>b', false },
          {
            'n',
            '<C-g>',
            require('diffview.actions').open_in_diffview,
            { desc = 'Open the entry under the cursor in a diffview' },
          },
          --adapted from https://github.com/lucobellic/nvim-config/blob/main/lua/plugins/git/diffview.lua
          -- Fixup commit under cursor
          {
            'n',
            '<C-s>',
            function()
              local lazy = require('diffview.lazy')
              ---@type FileHistoryView|LazyModule
              local FileHistoryView =
                lazy.access('diffview.scene.views.file_history.file_history_view', 'FileHistoryView')
              local view = require('diffview.lib').get_current_view()
              if view and view:instanceof(FileHistoryView.__get()) then
                ---@cast view DiffView|FileHistoryView
                local file = view:infer_cur_file()
                local item = view.panel:get_item_at_cursor()

                if file and item then
                  local nio = require('nio')
                  local path = file.absolute_path
                  nio.run(function()
                    nio.process.run({ cmd = 'git', args = { 'stash', '--keep-index' } }).result(true)
                    nio.process
                      .run({
                        cmd = 'git',
                        args = { 'commit', '--fixup=' .. item.commit.hash, '--', path },
                      })
                      .result(true)
                    nio.process.run({ cmd = 'git', args = { 'stash', 'pop', '--index' } }).result(true)
                    vim.notify('Fixup ' .. item.commit.hash, vim.log.levels.INFO)
                  end)
                end
              end
            end,
            { desc = 'Fixup current file staged change' },
          },
        },
      },
    }
  end,
}
