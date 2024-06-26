return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionWithBuffers]])

    require("codecompanion").setup({
      strategies = {
        chat = "ollama",
        inline = "ollama",
      },

      adapters = {
        ollama = require("codecompanion.adapters").use("ollama", {
          schema = {
            model = {
              default = "codeqwen",
            },
          },
        }),
      },
    })
  end,
  keys = {
    { "<leader>az", "<cmd>CodeCompanionToggle<CR>", desc = "AI Chat", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>CodeCompanion<CR>", desc = "AI Ask", mode = { "n", "v" } },
    { "<leader>ai", "<cmd>CodeCompanionActions<CR>", desc = "[A][I] List of actions", mode = { "n", "v" } },
  },
}
