return {
  {
    "MeanderingProgrammer/markdown.nvim",
    enabled = true,
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({
        latex = { enabled = false },
        acknowledge_conflicts = true,
      })
    end,
  },
}
