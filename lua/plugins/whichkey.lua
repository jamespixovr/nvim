return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      timeoutlen = 500,
      delay = 500,
      disable = {
        bt = {},
        ft = { 'TelescopePrompt' },
      },
      preset = 'modern',
      spec = {
        {
          mode = { 'n', 'v' },
          -- { '<leader>b', group = 'buffer' },
          { '<leader>c', group = 'code' },
          { '<leader>d', group = 'debugger' },
          { '<leader>f', group = 'file/find/telescope' },
          { '<leader>g', group = 'git/hunks' },
          { '<leader>i', group = 'ai' },
          { '<leader>h', group = 'hardtime/hurl' },
          { '<leader>n', group = 'noice' },
          { '<leader>o', group = 'task runner' },
          { '<leader>q', group = 'quit/session' },
          { '<leader>s', group = 'search' },
          { '<leader>t', group = 'test runner' },
          { '<leader>u', group = 'ui' },
          { '<leader>w', group = 'windows' },
          { '<leader>x', group = 'diagnostics/quickfix' },
          { 'z', group = 'fold' },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },
        },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Keymaps (which-key)',
      },
      {
        '<c-w><space>',
        function()
          require('which-key').show({ keys = '<c-w>', loop = true })
        end,
        desc = 'Window Hydra Mode (which-key)',
      },
    },
    config = function(_, opts)
      local wk = require('which-key')
      wk.setup(opts)
    end,
  },
}
