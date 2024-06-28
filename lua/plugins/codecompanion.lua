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
    { "<leader>at", "<cmd>CodeCompanionToggle<CR>", desc = "AI Chat", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>CodeCompanion<CR>", desc = "AI Ask", mode = { "n", "v" } },
    { "<leader>ai", "<cmd>CodeCompanionActions<CR>", desc = "[A][I] List of actions", mode = { "n", "v" } },
  },
}
