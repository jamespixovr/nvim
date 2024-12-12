return {
  'antoinemadec/FixCursorHold.nvim', -- This is needed to fix lsp doc highlight

  -----------------------------------------------------------------------------
  {
    'mbbill/undotree',
    cmd = 'UndotreeToggle',
    keys = {
      { '<Leader>uu', '<cmd>UndotreeToggle<CR>', desc = 'Undo Tree' },
    },
  },

  -----------------------------------------------------------------------------

  {
    'karb94/neoscroll.nvim',
    config = function()
      require('neoscroll').setup()
    end,
  },

  {
    'NvChad/nvim-colorizer.lua',
    event = 'BufReadPost',
    opts = {
      user_default_options = {
        names = false,
      },
      filetypes = {
        'css',
        'scss',
        eruby = { mode = 'foreground' },
        html = { mode = 'foreground' },
        'lua',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        yaml = { mode = 'background' },
        json = { mode = 'background' },
      },
    },
  },
  {
    -- display line numbers while going to a line with `:`
    'nacro90/numb.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('numb').setup({
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      })
    end,
  },
}
