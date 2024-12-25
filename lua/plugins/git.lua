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
  }
end
return {
  {
    'tpope/vim-fugitive',
  },

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
  {
    'NeogitOrg/neogit',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration
      'ibhagwan/fzf-lua',
    },
    cmd = 'Neogit',
    opts = {
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { '<leader>gn', '<cmd>Neogit kind=floating<cr>', desc = 'Neogit' },
    },
    config = true,
  },
  {
    'FabijanZulj/blame.nvim',
    lazy = true,
    cmd = 'BlameToggle',
    keys = {
      { '<leader>ga', '<cmd>BlameToggle window<cr>', desc = 'Git Blame' },
      {
        '<leader>ge',
        function()
          local current_file = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(0))
          if current_file then
            local result = vim
              .system({ 'git', 'blame', '-L' .. vim.fn.line('.') .. ',' .. vim.fn.line('.'), current_file }, { text = true })
              :wait()

            local commit_sha, _ = result.stdout:gsub('%s.*$', '')
            vim.cmd('DiffviewOpen ' .. commit_sha .. '^..' .. commit_sha)
          end
        end,
        desc = 'Blame Commit',
      },
    },
    opts = {
      commit_detail_view = function(sha, _row, _path)
        local NeogitCommitView = require('neogit.buffers.commit_view')
        local view = NeogitCommitView.new(sha)
        view:open('floating')

        view.buffer:set_window_option('scrollbind', false)
        view.buffer:set_window_option('cursorbind', false)
      end,
      merge_consecutive = true,
      mappings = {
        stack_push = ']]',
        stack_pop = '[[',
      },
    },
  },
}
