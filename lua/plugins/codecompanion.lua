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

    require("codecompanion").setup({
      strategies = {
        chat = "ollama",
        inline = "ollama",
      },

      adapters = {
        ollama = require("codecompanion.adapters").use("ollama", {
          schema = {
            model = {
              default = "deepseek-coder:6.7b",
            },
          },
        }),
      },
    })
  end,
  keys = {
    { "<leader>iz", "<cmd>CodeCompanionToggle<CR>", desc = "AI Chat", mode = { "n", "v" } },
    { "<leader>ib", "<cmd>CodeCompanion<CR>", desc = "AI Ask", mode = { "n", "v" } },
    { "<leader>il", "<cmd>CodeCompanionActions<CR>", desc = "A[I] [L]ist of actions", mode = { "n", "v" } },
  },
}
