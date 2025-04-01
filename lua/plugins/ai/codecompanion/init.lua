local helper = require('plugins.ai.codecompanion.helper')
local adapter = os.getenv('NVIM_AI_ADAPTER') or 'gemini'

return {
  'olimorris/codecompanion.nvim',
  version = false,
  dependencies = { 'j-hui/fidget.nvim' },
  cmd = { 'CodeCompanionChat', 'CodeCompanion', 'CodeCompanionCmd', 'CodeCompanionActions' },
  event = 'VeryLazy',
  keys = {
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'AI Toggle', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
    { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion Anthropic' },
    { '<leader>ag', ':CodeCompanionChat gemini<CR>', desc = 'Codecompanion: Gemini' },
    { '<leader>al', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion Ollama' },
    { '<leader>ao', ':CodeCompanionChat openai<CR>', desc = 'Codecompanion OpenAI' },
    { '<leader>ar', ':CodeCompanionChat openrouter<CR>', desc = 'Codecompanion OpenRouter' },
    {
      '<leader>aS',
      function()
        local name = vim.fn.input('Save as: ')
        if name and name ~= '' then
          vim.cmd('CodeCompanionSave ' .. name)
        end
      end,
      desc = 'Codecompanion save',
    },
    { '<leader>aL', ':CodeCompanionLoad<CR>', desc = 'Codecompanion load' },
  },
  opts = function()
    return {
      adapters = {
        openai = helper.openai_fn,
        anthropic = helper.anthropic_fn,
        ollama = helper.ollama_fn,
        gemini = helper.gemini_fn,
        openrouter = helper.openrouter_fn,
        deepseek = helper.deepseek_fn,
      },
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
    require('codecompanion').setup(opts)
  end,
  init = function()
    require('plugins.ai.codecompanion.spinner'):init()

    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionChat anthropic]])

    -- Disable line numbers in CodeCompanion chat
    local group = vim.api.nvim_create_augroup('CodeCompanionHooks', { clear = true })
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'CodeCompanionChat*',
      group = group,
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })
  end,
}
