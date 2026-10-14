local adapters = require('codecompanion.adapters.acp')

return {
  http = {
    opts = {
      show_presets = true,
    },
    extend = {
      deepseek = {
        env = { api_key = os.getenv('DEEPSEEK_API_KEY') },
        schema = {
          max_tokens = {
            default = 16384,
          },
        },
      },
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
  acp = {
    opts = {
      show_presets = false, -- only show user-defined adapters
      show_model_choices = true, -- show model choices
    },
    claude_code = function()
      return adapters.extend('claude_code', {
        defaults = {
          mcpServers = 'inherit_from_config',
          mode = 'plan',
          timeout = 20000, -- codecompanion's own timeout is 20 seconds for connection init
        },
        env = {
          -- CLAUDE_CODE_OAUTH_TOKEN = token,
          CLAUDE_CODE_OAUTH_TOKEN = 'cmd:cat ~/.claude_code_apitoken',
        },
      })
    end,
    gemini_cli = function()
      return adapters.extend('gemini_cli', {
        defaults = {
          timeout = 20000, -- 20 seconds
        },
      })
    end,
    codex = function()
      return adapters.extend('codex', {
        formatted_name = '\u{E4C6}  Codex',
        defaults = {
          timeout = 20000, -- codecompanion's own timeout is 20 seconds for connection init
          auth_method = 'chat-gpt', -- 'api-key'|'chat-gpt'
          mcpServers = 'inherit_from_config',
        },
      })
    end,
    copilot_acp = function()
      return adapters.extend('copilot_acp', {
        defaults = {
          timeout = 20000,
          session_config_options = {
            model = 'claude-opus-4-6',
          },
          mcpServers = 'inherit_from_config',
        },
      })
    end,
    opencode = function()
      return adapters.extend('opencode', {
        env = {
          PATH = vim.env['PATH'],
          HOME = vim.env['HOME'],
          USER = vim.env['USER'],
          OPENCODE_CONFIG = vim.fn.expand('~/.config/nvim/utils/agents/opencode/zen.json'),
          OPENCODE_API_KEY = vim.env['NVIM_OPENCODE_ACP_WORK'],
        },
        opts = {
          verbose_output = true,
        },
        defaults = {
          mcpServers = 'inherit_from_config',
          mode = 'plan',
        },
        commands = {
          default = { 'opencode', 'acp' },
        },
      })
    end,
  },
}
