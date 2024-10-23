local function terminal_keymaps()
  return {
    { '<leader>wt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
    { '<leader>wf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle Floating Terminal' },
    { '<leader>wh', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle Horizontal Terminal' },
    { '<leader>wv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle Vertical Terminal' },
  }
end
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

  -- toggle terminal
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    keys = terminal_keymaps(),
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = 'horizontal',
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
