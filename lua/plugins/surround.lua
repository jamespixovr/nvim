return {
  {
    'echasnovski/mini.surround',
    keys = {
      { 'S', mode = { 'x' } },
      'ys',
      'ds',
      'cs',
    },
    config = function()
      require('mini.surround').setup({
        mappings = {
          add = 'ys',
          delete = 'ds',
          replace = 'cs',
          find = '',
          find_left = '',
          highlight = '',
          update_n_lines = '',
        },
      })

      vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]])
    end,
  },
  {
    'kylechui/nvim-surround',
    enabled = false,
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    -- enabled = false,
    event = 'VeryLazy',
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
