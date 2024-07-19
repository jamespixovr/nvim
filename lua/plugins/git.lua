return {
  {
    "tpope/vim-fugitive",
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPost", "BufWritePre" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = require("config.keymaps").gitsigns_keymaps(),
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
      },
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      diff_opts = { internal = true },
      current_line_blame_opts = { delay = 500 },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <abbrev_sha> - <summary>",
    },
  },
  {
    "NeogitOrg/neogit",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    opts = {
      integrations = {
        diffview = true,
      },
    },
    keys = require("config.keymaps").neogit_keymaps(),
    config = true,
  },
}
