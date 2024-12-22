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
}
