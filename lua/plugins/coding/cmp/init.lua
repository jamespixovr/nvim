return {
  {
    import = 'plugins.coding.cmp.nvim-cmp',
    enabled = function()
      return vim.g.cmploader == 'nvim-cmp'
    end,
  },
  {
    import = 'plugins.coding.cmp.blink-cmp',
    enabled = function()
      return vim.g.cmploader == 'blink.cmp'
    end,
  },
}
