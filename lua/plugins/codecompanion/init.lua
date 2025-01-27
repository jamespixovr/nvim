local helper = require('plugins.codecompanion.helper')
local user = vim.env.USER or 'Jarmex'

return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
    { 'saghen/blink.cmp', enabled = vim.g.cmploader == 'blink.cmp' },
  },
  config = function()
    local adapter = os.getenv('NVIM_AI_ADAPTER') or 'anthropic'
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionChat anthropic]])

    require('codecompanion').setup({
      adapters = {
        openai = helper.openai_fn,
        anthropic = helper.anthropic_fn,
        ollama = helper.ollama_fn,
        gemini = helper.gemini_fn,
      },
      strategies = {
        chat = {
          adapter = adapter,
          -- roles = { llm = ' CodeCompanion', user = 'Jarmex' },
          roles = {
            llm = '  CodeCompanion',
            user = ' ' .. user:sub(1, 1):upper() .. user:sub(2),
          },
          slash_commands = {
            ['buffer'] = {
              opts = {
                provider = 'fzf_lua',
              },
            },
            ['help'] = {
              opts = {
                provider = 'fzf_lua',
              },
            },
            ['file'] = {
              opts = {
                provider = 'fzf_lua',
              },
            },
            ['symbols'] = {
              opts = {
                provider = 'fzf_lua',
              },
            },
          },
        },
        inline = {
          adapter = adapter,
        },
        agent = {
          adapter = adapter,
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
      prompt_library = require('plugins.codecompanion.prompts').to_codecompanion(),
    })
  end,
  keys = {
    { 'ga', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'AI Toggle', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
    { '<leader>an', ':CodeCompanionChat anthropic<CR>', desc = 'Codecompanion Anthropic' },
    { '<leader>ag', ':CodeCompanionChat gemini<CR>', desc = 'Codecompanion: Gemini' },
    { '<leader>al', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion OpenAI' },
    { '<leader>ao', ':CodeCompanionChat openai<CR>', desc = 'Codecompanion Ollama' },
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
}
