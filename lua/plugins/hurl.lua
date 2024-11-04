return {
  -- - HTTP client
  {
    'jellydn/hurl.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    ft = { 'hurl' },
    opts = {
      debug = false,
      show_notification = false,
      mode = 'popup', -- split or popup
      formatters = {
        json = { 'jq' },
        html = {
          'prettierd',
          '--parser',
          'html',
        },
      },
    },
    keys = {
      { '<leader>hA', '<cmd>HurlRunner<CR>', desc = 'Run All requests' },
      { '<leader>ha', '<cmd>HurlRunnerAt<CR>', desc = 'Run Api request' },
      { '<leader>hh', ':HurlRunner<CR>', desc = 'Hurl Runner', mode = 'v' },
    },
  },
}
