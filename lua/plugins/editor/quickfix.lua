return {
  'kevinhwang91/nvim-bqf', -- Better quickfix window,
  ft = 'qf',
  opts = {
    auto_enable = true,
    auto_resize_height = false,
    func_map = {
      open = '<cr>',
      openc = 'o',
      vsplit = 'v',
      split = 's',
      fzffilter = 'f',
      pscrollup = '<C-u>',
      pscrolldown = '<C-d>',
      ptogglemode = 'F',
      filter = 'n',
      filterr = 'N',
    },
  },
}
