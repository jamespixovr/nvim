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
        mode = { 'n', 'v' },
        { '<leader>b', group = 'buffer' },
        { '<leader>c', group = 'code' },
        { '<leader>d', group = 'debugger' },
        { '<leader>f', group = 'file/find/telescope' },
        { '<leader>g', group = 'git/hunks' },
        { '<leader>i', group = 'ai' },
        { '<leader>h', group = 'hardtime' },
        { '<leader>n', group = 'noice' },
        { '<leader>o', group = 'task runner' },
        { '<leader>q', group = 'quit/session' },
        { '<leader>s', group = 'search' },
        { '<leader>t', group = 'test runner' },
        { '<leader>u', group = 'ui' },
        { '<leader>w', group = 'windows' },
        { '<leader>x', group = 'diagnostics/quickfix' },
        { '[', group = 'prev' },
        { ']', group = 'next' },
      },
    },
  },
}
