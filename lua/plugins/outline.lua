return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    enabled = false,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>ss', '<cmd>Outline<cr>', desc = 'Toggle Outline' },
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
      { '<leader>ss', '<cmd>Namu symbols<cr>', desc = 'Toggle Outline' },
    },
  },
}
