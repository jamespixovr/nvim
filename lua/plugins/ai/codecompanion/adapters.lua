return {
  --- Anthropic config for CodeCompanion.
  anthropic = function()
    local anthropic_config = {
      schema = {
        model = {
          default = 'claude-3-7-sonnet-latest',
        },
        max_tokens = {
          default = 8192,
          -- default = 28000,
        },
        extended_output = {
          default = false,
        },
        extended_thinking = {
          default = false,
        },
      },
    }
    return require('codecompanion.adapters').extend('anthropic', anthropic_config)
  end,

  --- OpenAI config for CodeCompanion.
  openai = function()
    local openai_config = {
      schema = {
        model = {
          default = 'gpt-4.1-mini',
        },
      },
    }
    return require('codecompanion.adapters').extend('openai', openai_config)
  end,

  deepseek = function()
    return require('codecompanion.adapters').extend('deepseek', {
      env = {
        api_key = os.getenv('DEEPSEEK_API_KEY'),
      },
      schema = {
        model = {
          default = 'deepseek-chat',
          -- default = 'deepseek-reasoner',
        },
        temperature = {
          default = 0.3,
        },
      },
    })
  end,

  --- Ollama config for CodeCompanion.
  ollama = function()
    return require('codecompanion.adapters').extend('ollama', {
      name = 'ollama',
      schema = {
        model = {
          default = 'qwen2.5-coder:3b',
        },
        num_ctx = {
          default = 20000,
        },
        temperature = {
          default = 0.3,
        },
        num_predict = {
          default = -1,
        },
      },
    })
  end,

  --- Gemini config for CodeCompanion.
  gemini = function()
    local gemini_config = {
      schema = {
        temperature = { default = 0.2 },
        num_ctx = { default = 200000 },
      },
    }
    return require('codecompanion.adapters').extend('gemini', gemini_config)
  end,

  --- Gemini config for CodeCompanion.
  openrouter = function()
    local openrouter_config = {
      name = 'openrouter',
      formatted_name = 'OpenRouter',
      url = 'https://openrouter.ai/api/v1/chat/completions',
      env = {
        api_key = os.getenv('OPENROUTER_API_KEY'),
      },
      schema = {
        temperature = { default = 0.3 },
        maxOutputTokens = { default = 8192 },
        model = {
          default = 'qwen/qwen-2.5-coder-32b-instruct:free',
          choices = {
            ['deepseek/deepseek-r1:free'] = { opts = { can_reason = true } },
            'qwen/qwen-2.5-coder-32b-instruct:free',
            'deepseek/deepseek-r1-distill-llama-70b:free',
            'deepseek/deepseek-chat:free',
            'mistralai/mistral-small-24b-instruct-2501:free',
            ['google/gemini-2.0-flash-exp:free'] = { opts = { can_reason = true } }, -- context: 1.05M
            ['google/gemini-2.0-pro-exp-02-05:free'] = { opts = { can_reason = true } }, -- context: 2M
            ['google/gemini-2.0-flash-thinking-exp-1219:free'] = { opts = { can_reason = true } }, -- context: 40K
          },
        },
        num_ctx = { default = 200000 },
      },
    }
    return require('codecompanion.adapters').extend('openai_compatible', openrouter_config)
  end,
}
