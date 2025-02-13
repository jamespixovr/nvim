return {
  {
    'karb94/neoscroll.nvim',
    enabled = true,
    config = function()
      require('neoscroll').setup({ easing_function = 'quadratic' })
    end,
  },
}
