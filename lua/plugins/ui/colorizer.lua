return {
  'catgoose/nvim-colorizer.lua',
  enabled = true,
  event = 'BufReadPre',
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
}
