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
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            schema = {
              model = {
                default = 'claude-3-5-sonnet-20240620',
              },
            },
          })
        end,
        defaultllm = function()
          return require('codecompanion.adapters').extend('ollama', {
            name = 'defaultllm',
            schema = {
              model = {
                default = 'qwen2.5-coder',
              },
              num_ctx = {
                default = 16384,
              },
              temperature = {
                default = 0.5,
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
          adapter = 'anthropic',
        },
        agent = {
          adapter = 'anthropic',
        },
      },
      -- adapted from https://github.com/SDGLBL/dotfiles/tree/main/.config/nvim/lua/plugins
      actions = {
        require('plugins.codecompanion.actions').translate,
        require('plugins.codecompanion.actions').write,
      },
      display = {
        inline = {
          diff = {
            enabled = true,
          },
        },
        chat = {
          show_settings = true,
        },
      },
    })
  end,
  keys = require('config.keymaps').codecompanion_keymaps(),
}
