return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>ss', '<cmd>Outline<cr>', desc = 'Toggle Outline' },
    },
    opts = {},
  },
}
