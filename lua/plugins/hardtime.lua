return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>hd", "<cmd>Hardtime disable<cr>", desc = "Hard Time Toggle" },
    { "<leader>he", "<cmd>Hardtime enable<cr>",  desc = "Hard Time Toggle" },
  },
  opts = {
    allow_different_key = true,
    disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason", "ToggleTerm", "alpha" },
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
