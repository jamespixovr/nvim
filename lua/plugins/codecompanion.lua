return {
  'olimorris/codecompanion.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim', -- Optional
    'stevearc/dressing.nvim', -- Optional: Improves the default Neovim UI
  },
  config = function()
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionWithBuffers]])

    require('codecompanion').setup({
      use_default_prompts = true,
      adapters = {
        ollama = require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = {
              default = 'codeqwen',
            },
            num_ctx = {
              default = 16384,
            },
            num_predict = {
              default = -1,
            },
          },
        }),
        codegemma = require('codecompanion.adapters').extend('ollama', {
          schema = {
            model = {
              default = 'codegemma',
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
          adapter = 'ollama',
        },
        inline = {
          adapter = 'codegemma',
        },
        agent = {
          adapter = 'ollama',
        },
      },
    })
  end,
  keys = require('config.keymaps').codecompanion_keymaps(),
}
