local function terminal_keymaps()
  return {
    { [[<c-\>]], '<cmd>ToggleTerm<cr>', mode = 'n', desc = 'Toggle Terminal' },
    { '<leader>wt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
    { '<leader>wf', '<cmd>ToggleTerm directio=float<cr>', desc = 'Toggle Floating Terminal' },
    { '<leader>wh', '<cmd>ToggleTerm size=15 direction=horizontal<cr>', desc = 'Toggle Horizontal Terminal' },
    { '<leader>wv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle Vertical Terminal' },
  }
end

return {
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    keys = terminal_keymaps(),
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = 'horizontal',
      size = 20,
      float_opts = {
        border = 'curved',
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
    },
  },
}
