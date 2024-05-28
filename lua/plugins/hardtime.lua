return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>hd", "<cmd>Hardtime disable<cr>", desc = "Hard Time Disable" },
    { "<leader>he", "<cmd>Hardtime enable<cr>",  desc = "Hard Time Enable" },
  },
  opts = {
    max_count = 3,
    enabled = true,
    allow_different_key = true,
    disabled_filetypes = {
      "TelescopePrompt",
      "notify",
      "Diffview*",
      "Dressing*",
      "Neogit*",
      "NvimTree",
      "Outline",
      "ToggleTerm",
      "Trouble",
      "alpha",
      "checkhealth",
      "dapui*",
      "help",
      "httpResult",
      "lazy",
      "mason",
      "neotest-summary",
      "netrw",
      "noice",
      "notify",
      "oil",
      "prompt",
      "qf",
      "undotree",
    },
    hints = {
      ["[dcyvV][ia]%("] = {
        message = function(keys)
          return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
        end,
        length = 3,
      },
    },
  },
}
