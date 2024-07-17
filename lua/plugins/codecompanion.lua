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
  keys = require("config.keymaps").codecompanion_keymaps(),
}
