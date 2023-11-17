return {
  -- rename
  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    keys = {
      { "<leader>ss", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
    },
    opts = {
      width = 30,
      autofold_depth = 0,
      keymaps = {
        hover_symbol = 'K',
        toggle_preview = 'p',
      },
    },
  },
  --- HTTP client
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    config = function()
      require("rest-nvim").setup({})
    end
  },
}
