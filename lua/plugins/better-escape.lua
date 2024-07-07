return {
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup({
        mappaings = {
          i = {
            j = {
              k = "<Esc>",
              j = "<Esc>",
            },
          },
        },
      })
    end,
  },
}
