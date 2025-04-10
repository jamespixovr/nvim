return {
  'olimorris/codecompanion.nvim',
  version = false,
  dependencies = { 'j-hui/fidget.nvim' },
  cmd = { 'CodeCompanionChat', 'CodeCompanion', 'CodeCompanionCmd', 'CodeCompanionActions' },
  event = 'VeryLazy',
  keys = require('plugins.ai.codecompanion.keymaps'),
  opts = function()
    local adapter = os.getenv('NVIM_AI_ADAPTER') or 'gemini'
    local helper = require('plugins.ai.codecompanion.helper')

    return {
      adapters = require('plugins.ai.codecompanion.adapters'),
      strategies = {
        chat = {
          keymaps = {
            close = {
              modes = { n = { 'q', '<C-c>' }, i = '<C-c>' },
            },
          },
          adapter = adapter,
          roles = helper.roles(),
          tools = require('plugins.ai.codecompanion.tools'),
          slash_commands = require('plugins.ai.codecompanion.slash_commands'),
        },
        inline = { adapter = adapter },
        agent = {
          adapter = adapter,
          tools = { opts = { auto_submit_errors = true } },
        },
      },
      display = {
        diff = {
          close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = 'vertical', -- vertical|horizontal split for default provider
          opts = { 'internal', 'filler', 'closeoff', 'algorithm:patience', 'followwrap', 'linematch:120' },
          provider = 'mini_diff', -- default|mini_diff
        },
        inline = { diff = { enabled = true } },
        chat = {
          show_settings = false,
          render_headers = true,
          window = {
            opts = {
              number = false,
              relativenumber = false,
            },
          },
        },
        action_palette = {
          prompt = 'Prompt ', -- Prompt used for interactive LLM calls
          provider = 'telescope', -- Can be "default", "telescope", or "mini_pick". If not specified, the plugin will autodetect installed providers.
          opts = {
            show_default_actions = true, -- Show the default actions in the action palette?
            show_default_prompt_library = true, -- Show the default prompt library in the action palette?
          },
        },
      },
      prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
      -- opts = {
      -- local system_prompt = require("codecompanion.config").config.opts.system_prompt
      --   system_prompt = require('plugins.ai.codecompanion.system_prompt'),
      -- },
    }
  end,
  config = function(_, opts)
    -- vim.g.codecompanion_auto_tool_mode = true
    require('codecompanion').setup(opts)
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionChat anthropic]])

    require('plugins.ai.codecompanion.spinner'):init()
  end,
}
