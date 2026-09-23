---@module "codecompanion"
---@type CodeCompanion.Config
return {
  http = {
    opts = {
      show_presets = true,
    },
    extend = {
      anthropic = { env = {} },
      deepseek = {
        env = { api_key = os.getenv('DEEPSEEK_API_KEY') },
        schema = {
          max_tokens = {
            default = 16384,
          },
        },
      },
      gemini = {},
      openai = {},
      openai_responses = {},
      openrouter = {
        env = { api_key = os.getenv('OPENROUTER_API_KEY') },
        schema = {
          model = {
            default = '~deepseek/deepseek-v4-flash-latest',
          },
        },
      },
    },
    openrouter_background = function()
      return require('codecompanion.adapters').extend('openrouter', {
        env = { api_key = 'OPENROUTER_API_KEY' },
        opts = { session_id = 'title_generation' },
        schema = {
          model = { default = 'deepseek/deepseek-v4-flash-0731' },
          ['reasoning.effort'] = { enabled = false },
        },
      })
    end,
    qwen = function()
      return require('codecompanion.adapters').extend('openai_compatible', {
        name = 'qwen',
        formatted_name = 'Qwen',
        env = {
          url = 'https://dashscope-intl.aliyuncs.com/compatible-mode',
          chat_url = '/v1/chat/completions',
          api_key = os.getenv('QWEN_API_KEY'),
        },
        schema = {
          model = {
            default = 'qwen3.7-flash',
            choices = {
              'qwen3.8-max',
            },
          },
        },
      })
    end,
  },
  acp = require('plugins.ai.codecompanion.adapters.acp'),
}
