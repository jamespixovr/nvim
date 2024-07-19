return {
  {
    "MeanderingProgrammer/markdown.nvim",
    enabled = false,
    name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    config = function()
      require("render-markdown").setup({
        headings = {
          "󰼏 ",
          "󰼐 ",
          "󰼑 ",
          "󰼒 ",
          "󰼓 ",
          "󰼔 ",
        },
        dash = "━",
        bullets = { "", "", "", "" },

        checkbox = {
          unchecked = "󰄰 ",
          checked = "󰄯 ",
        },
        quote = "▍",
      })
    end,
  },

  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
