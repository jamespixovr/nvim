return {
  {
    'FabijanZulj/blame.nvim',
    cmd = 'BlameToggle',
    keys = {
      { '<leader>gm', '<Cmd>BlameToggle window<CR>', desc = 'Git Blame' },
    },
    config = function()
      require('blame').setup({
        date_format = '%Y-%m-%d',
        format_fn = require('blame.formats.default_formats').commit_date_author_fn,
        -- format_fn = require('blame.formats.default_formats').date_message,
        blame_options = {
          '-w', -- skip blame which adjust white space only
        },
        mappings = {
          commit_info = 'i', -- brief commit information (commit title)
          show_commit = '<CR>', -- full commit information (commit contents)
          stack_push = '<TAB>', -- show entire code selected commit in current buffer (go before)
          stack_pop = '<BS>', -- restore from stack push
          close = { '<esc>', 'q' },
        },
      })
    end,
  },
}
