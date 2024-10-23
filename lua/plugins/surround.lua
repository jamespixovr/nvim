return {
  {
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    -- enabled = false,
    lazy = true,
    keys = {
      'ys',
      'ds',
      'cs',
      { 'S', mode = 'x' },
      { '<C-g>s', mode = 'i' },
    },
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          insert = '<C-g>s',
          insert_line = '<C-g>S',
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
        },
        aliases = {
          ['a'] = '<',
          ['b'] = '(',
          ['B'] = '{',
          ['r'] = '[',
          ['q'] = { '"', "'", '`' },
          ['s'] = { '{', '[', '(', '<', '"', "'", '`' },
        },
        highlight = {
          duration = 500,
        },
      })
    end,
  },
}
