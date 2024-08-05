return {
  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    cmd = "Spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },
}
