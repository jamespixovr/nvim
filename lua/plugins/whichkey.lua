return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      window = {
        border = "single", -- none, single, double, shadow
      },
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        mode = { "n", "v" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debugger" },
        { "<leader>f", group = "file/find/telescope" },
        { "<leader>g", group = "git/hunks" },
        { "<leader>h", group = "hardtime" },
        { "<leader>n", group = "noice" },
        { "<leader>o", group = "task runner" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test runner" },
        { "<leader>u", group = "ui" },
        { "<leader>v", group = "venv" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      })
    end,
  },
}
