return {
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    keys = require('config.keymaps').symbols_outline_keymaps(),
    opts = {},
  },
}
