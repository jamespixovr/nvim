-- adapted from https://github.com/fredrikaverpil/dotfiles/blob/main/nvim-fredrik/lua/fredrik/plugins/codecompanion.lua
local user = vim.env.USER or 'Jarmex'

local M = {}

M.roles = function()
  return {
    ---@type string|fun(adapter: CodeCompanion.Adapter): string
    llm = function(llm)
      return '  ' .. llm.formatted_name .. '(' .. llm.schema.model.default .. ')'
    end,
    user = ' ' .. user:sub(1, 1):upper() .. user:sub(2),
  }
end

--- Anthropic config for CodeCompanion.
local anthropic_fn = function()
  local anthropic_config = {
    schema = {
      model = {
        default = 'claude-3-7-sonnet-latest',
      },
      max_tokens = {
        -- default = 8192,
        default = 18000,
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
end

--- OpenAI config for CodeCompanion.
local openai_fn = function()
  local openai_config = {
    schema = {
      model = {
        -- default = 'gpt-4o',
        default = 'o3-mini-2025-01-31',
      },
    },
  }
  return require('codecompanion.adapters').extend('openai', openai_config)
end

local deepseek_fn = function()
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
end

--- Ollama config for CodeCompanion.
local ollama_fn = function()
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
end

--- Gemini config for CodeCompanion.
local gemini_fn = function()
  local gemini_config = {
    schema = {
      temperature = { default = 0.2 },
      num_ctx = { default = 200000 },
    },
  }
  return require('codecompanion.adapters').extend('gemini', gemini_config)
end

--- Gemini config for CodeCompanion.
local openrouter_fn = function()
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
end

M.adapters = function()
  return {
    openai = openai_fn,
    anthropic = anthropic_fn,
    ollama = ollama_fn,
    gemini = gemini_fn,
    openrouter = openrouter_fn,
    deepseek = deepseek_fn,
  }
end

-- add 2 commands:
--    CodeCompanionSave [space delimited args]
--    CodeCompanionLoad
-- Save will save current chat in a md file named 'space-delimited-args.md'
-- Load will use a telescope filepicker to open a previously saved chat

-- create a folder to store our chats
local Path = require('plenary.path')
local data_path = vim.fn.stdpath('data') -- ~/.local/share/<NVIM_APPNAME>
local save_folder = Path:new(data_path, 'codecompanion_chats')
if not save_folder:exists() then
  save_folder:mkdir({ parents = true })
end

-- telescope picker for our saved chats
vim.api.nvim_create_user_command('CodeCompanionLoad', function()
  local t_builtin = require('telescope.builtin')
  local t_actions = require('telescope.actions')
  local t_action_state = require('telescope.actions.state')
  local t_pickers = require('telescope.pickers')
  local t_finders = require('telescope.finders')
  local t_conf = require('telescope.config').values

  -- list of supported adapters
  local adapters = {
    'anthropic',
    'openai',
    'gemini',
    'ollama',
    'openrouter',
    'deepseek',
  }

  local function select_adapter(filepath)
    local picker = t_pickers.new({}, {
      prompt_title = 'Select CodeCompanion Adapter',
      finder = t_finders.new_table({
        results = adapters,
      }),
      sorter = t_conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, _)
        t_actions.select_default:replace(function()
          t_actions.close(prompt_bufnr)
          local selection = t_action_state.get_selected_entry()
          local adapter = selection[1]

          -- Open new CodeCompanion chat with selected adapter
          vim.cmd('CodeCompanionChat ' .. adapter)

          -- Read contents of saved chat file
          local lines = vim.fn.readfile(filepath)

          -- Get the current buffer (which should be the new CodeCompanion chat)
          local current_buf = vim.api.nvim_get_current_buf()

          -- Paste contents into the new chat buffer
          vim.api.nvim_buf_set_lines(current_buf, 0, -1, false, lines)
        end)
        return true
      end,
    })
    picker:find()
  end

  local function start_picker()
    t_builtin.find_files({
      prompt_title = 'Saved CodeCompanion Chats | <c-d>: delete',
      cwd = save_folder:absolute(),
      attach_mappings = function(prompt_bufnr, map)
        map('i', '<c-d>', function()
          local selection = t_action_state.get_selected_entry()
          local filepath = selection.path or selection.filename
          os.remove(filepath)
          t_actions.close(prompt_bufnr)
          start_picker()
        end)

        t_actions.select_default:replace(function()
          local selection = t_action_state.get_selected_entry()
          local filepath = selection.path or selection.filename
          t_actions.close(prompt_bufnr)
          select_adapter(filepath)
        end)
        return true
      end,
    })
  end
  start_picker()
end, {})

-- save current chat, `CodeCompanionSave foo bar baz` will save as 'foo-bar-baz.md'
vim.api.nvim_create_user_command('CodeCompanionSave', function(opts)
  local codecompanion = require('codecompanion')
  local success, chat = pcall(function()
    return codecompanion.buf_get_chat(0)
  end)
  if not success or chat == nil then
    vim.notify('CodeCompanionSave should only be called from CodeCompanion chat buffers', vim.log.levels.ERROR)
    return
  end
  if #opts.fargs == 0 then
    vim.notify('CodeCompanionSave requires at least 1 arg to make a file name', vim.log.levels.ERROR)
  end
  local save_name = table.concat(opts.fargs, '-') .. '.md'
  local save_path = Path:new(save_folder, save_name)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  save_path:write(table.concat(lines, '\n'), 'w')
end, { nargs = '*' })

return M
