return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
  opts = {
    allow_different_key = true,
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
