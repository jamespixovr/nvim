return {
  {
    'theKnightsOfRohan/csvlens.nvim',
    ft = { 'csv' },
    dependencies = {
      'akinsho/toggleterm.nvim',
    },
    cmd = { 'Csvlens' },
    keys = {
      { '<leader>cv', '<cmd>Csvlens "|"<cr>', desc = "CSV Lens with '|' separator", mode = { 'n', 'v' } },
    },
    config = true,
  },
}
