return {
  {
    -- Code Runner / Scratchpad
    "metakirby5/codi.vim",
    cmd = { "CodiNew", "Codi", "CodiExpand" },
  },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" } },
  },

  -- Git
  "tpope/vim-fugitive",
}
