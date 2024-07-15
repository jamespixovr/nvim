-- Lazy.nvim
return {
  "olimorris/codecompanion.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "grapp-dev/nui-components.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
      },
    },
    "stevearc/dressing.nvim", -- Optional: Improves the default Neovim UI
  },
  config = function()
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionWithBuffers]])

    require("codecompanion").setup({
      adapters = {
        codeqwen = require("codecompanion.adapters").use("ollama", {
          schema = {
            model = {
              default = "codeqwen",
            },
            num_ctx = {
              default = 16384,
            },
            num_predict = {
              default = -1,
            },
          },
        }),
      },
      strategies = {
        chat = {
          adapter = "codeqwen",
        },
        inline = {
          adapter = "codeqwen",
        },
        agent = {
          adapter = "anthropic",
        },
      },
    })
  end,
  keys = {
    { "<leader>av", "<cmd>CodeCompanionAdd<cr>", mode = { "v" }, desc = "Add Visual" },
    { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = { "n", "v" }, desc = "InlineCode" },
    { "<leader>at", "<cmd>CodeCompanionToggle<CR>", desc = "AI Toggle", mode = { "n", "v" } },
    { "<leader>ac", "<cmd>CodeCompanionChat<CR>", desc = "AI Chat", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>CodeCompanionActions<CR>", desc = "[A]I [A]ctions", mode = { "n", "v" } },
  },
}
