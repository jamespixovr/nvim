return {
  'olimorris/codecompanion.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
    'stevearc/dressing.nvim',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionWithBuffers]])

    require('codecompanion').setup({
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            schema = {
              model = {
                default = 'gpt-4o',
              },
            },
          })
        end,
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            schema = {
              model = {
                default = 'claude-3-5-sonnet-latest',
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
                default = 0.8,
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
          roles = { llm = ' CodeCompanion', user = 'Me' },
        },
        inline = {
          adapter = 'defaultllm',
        },
        agent = {
          adapter = 'anthropic',
          tools = {
            opts = {
              auto_submit_errors = true,
            },
          },
        },
      },
      display = {
        diff = {
          close_chat_at = 500,
          provider = 'mini_diff',
        },
        inline = {
          diff = {
            enabled = true,
          },
        },
        chat = {
          show_settings = false,
          render_headers = false,
        },
      },
      opts = {
        log_level = 'DEBUG',
      },
      -- adapted from https://github.com/SDGLBL/dotfiles/tree/main/.config/nvim/lua/plugins
      -- actions = {
      --   require('plugins.codecompanion.actions').translate,
      --   require('plugins.codecompanion.actions').write,
      -- },
      --
    })
  end,
  keys = {
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'AI Toggle', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
    { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion: Ollama' },
  },
}
