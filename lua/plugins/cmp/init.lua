return {
  {
    import = 'plugins.cmp.nvim-cmp',
    enabled = function()
      return vim.g.cmploader == 'nvim-cmp'
    end,
  },
  {
    import = 'plugins.cmp.blink-cmp',
    enabled = function()
      return vim.g.cmploader == 'blink.cmp'
    end,
  },
}
