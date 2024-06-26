-- Lazy.nvim
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  init = function()
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
  config = function()
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
  end,
  keys = {
    { "<leader>iz", "<cmd>CodeCompanionToggle<CR>", desc = "AI Chat", mode = { "n", "v" } },
    { "<leader>ib", "<cmd>CodeCompanion<CR>", desc = "AI Ask", mode = { "n", "v" } },
    { "<leader>il", "<cmd>CodeCompanionActions<CR>", desc = "A[I] [L]ist of actions", mode = { "n", "v" } },
  },
}
