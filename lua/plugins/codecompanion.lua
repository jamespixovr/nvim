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
        defaultllm = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'defaultllm',
            schema = {
              model = {
                default = 'codeqwen:v1.5-chat',
              },
              num_ctx = {
                default = 16384,
              },
              num_predict = {
                default = -1,
              },
            },
          })
        end,
        codegemma = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'codegemma',
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
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'defaultllm',
        },
        inline = {
          adapter = 'codegemma',
        },
        agent = {
          adapter = 'defaultllm',
        },
      },
    })
  end,
  keys = require('config.keymaps').codecompanion_keymaps(),
}
