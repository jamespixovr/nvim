local adapters = require('plugins.ai.codecompanion.adapters')
local helper = require('plugins.ai.codecompanion.helper')

return {
  'olimorris/codecompanion.nvim',
  version = false,
  dependencies = { 'j-hui/fidget.nvim' },
  cmd = { 'CodeCompanionChat', 'CodeCompanion', 'CodeCompanionCmd', 'CodeCompanionActions' },
  event = 'VeryLazy',
  keys = require('plugins.ai.codecompanion.keymaps'),
  opts = function()
    local adapter = os.getenv('NVIM_AI_ADAPTER') or 'gemini'

    return {
      adapters = adapters,
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
        diff = { close_chat_at = 500, provider = 'mini_diff' },
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
      },
      prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
      -- opts = {
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
