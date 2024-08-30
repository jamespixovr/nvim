local prompts = require('plugins.codecompanion.codeexpert')

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
      adapters = {
        localllm = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'localllm',
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
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'localllm',
        },
        inline = {
          adapter = 'localllm',
        },
        agent = {
          adapter = 'localllm',
        },
      },
      default_prompts = prompts.default_prompts,
    })
  end,
  keys = require('config.keymaps').codecompanion_keymaps(),
}
