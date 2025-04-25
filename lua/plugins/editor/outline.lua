return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>so', '<cmd>Outline<cr>', desc = 'Toggle Outline' },
    },
    opts = {},
  },

  {
    'bassamsdata/namu.nvim',
    cmd = { 'Namu' },
    config = function()
      require('namu').setup({
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        ui_select = { enable = false }, -- vim.ui.select() wrapper
      })
    end,
    keys = {
      {
        '<leader>ss',
        function()
          require('namu.namu_symbols').show()
        end,
        desc = 'Toggle Outline',
        mode = { 'n', 'x', 'o' },
      },
    },
  },
}
