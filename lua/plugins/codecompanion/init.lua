local helper = require('plugins.codecompanion.helper')
local user = vim.env.USER or 'Jarmex'

return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  dependencies = { 'j-hui/fidget.nvim' },
  config = function()
    local adapter = os.getenv('NVIM_AI_ADAPTER') or 'anthropic'
    -- Expand `cc` into CodeCompanion in the command line
    vim.cmd([[cab cc CodeCompanion]])
    vim.cmd([[cab ccb CodeCompanionChat anthropic]])

    require('codecompanion').setup({
      -- system_prompts = require('plugins.codecompanion.prompts').SystemPrompt,
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
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(adapterllm)
              return '  CodeCompanion' .. '(' .. adapterllm.formatted_name .. ')'
            end,
            user = ' ' .. user:sub(1, 1):upper() .. user:sub(2),
          },
          slash_commands = {
            ['buffer'] = {
              opts = {
                provider = 'snacks',
                keymaps = {
                  modes = {
                    i = '<C-b>',
                  },
                },
              },
            },
            ['help'] = {
              opts = {
                provider = 'snacks',
                max_lines = 1000,
              },
            },
            ['file'] = {
              opts = {
                provider = 'snacks',
              },
            },
            ['symbols'] = {
              opts = {
                provider = 'snacks',
              },
            },
            ['git_files'] = require('plugins.codecompanion.slash_commands.git_files'),
            ['git_commit'] = require('plugins.codecompanion.slash_commands.git_commit'),
            ['thinking'] = require('plugins.codecompanion.slash_commands.thinking'),
            ['codeforces_companion'] = require('plugins.codecompanion.slash_commands.codeforces_companion'),
            ['review_merge_request'] = require('plugins.codecompanion.slash_commands.review_merge_request'),
            ['review_git_diffs'] = require('plugins.codecompanion.slash_commands.review_git_diffs'),
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
    require('plugins.codecompanion.spinner'):init()

    -- Disable line numbers in CodeCompanion chat
    local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})
    vim.api.nvim_create_autocmd({ 'User' }, {
      pattern = 'CodeCompanionChatOpened',
      group = group,
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })
    -----
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
