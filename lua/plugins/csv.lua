return {
  {
    'theKnightsOfRohan/csvlens.nvim',
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    cmd = { 'Csvlens' },
    keys = {
      { '<leader>cv', '<cmd>Csvlens "|"<cr>', desc = "CSV Lens with '|' separator", mode = { 'n', 'v' } },
    },
    event = 'VeryLazy',
    config = true,
  },
}
