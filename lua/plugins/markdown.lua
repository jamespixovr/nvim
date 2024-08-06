return {
  {
    'MeanderingProgrammer/markdown.nvim',
    enabled = false,
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('render-markdown').setup({
        latex = { enabled = false },
        acknowledge_conflicts = true,
      })
    end,
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false, -- Recommended
    -- ft = "markdown" -- If you decide to lazy-load anyway
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
}
