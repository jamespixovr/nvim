return {
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>jj", "<cmd>TSJToggle<cr>", desc = "TS Join Toggle" },
      { "<leader>je", "<cmd>TSJSplit<cr>",  desc = "TS Split" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },
}
