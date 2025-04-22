-- Flash enhances the built-in search functionality by showing labels
-- at the end of each match, letting you quickly jump to a specific
-- location.
return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      'zs',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Fla[s][h]',
    },
    {
      'zS',
      mode = { 'n', 'o', 'x' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flas[h] Tree[s]itter',
    },
    {
      '<leader>hr',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = '[R]emote Flas[h]',
    },
    {
      '<leader>hT',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Flas[h] [T]reesitter Search',
    },
  },
}
