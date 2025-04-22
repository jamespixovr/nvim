local M = {}
-- Store the default prompt from codecompanion config
M.default_prompt = require('codecompanion.config').opts.system_prompt

-- Table to store registered modes and prompts
M.modes = {}

-- Register a new mode
function M.register_mode(name, module)
  M.modes[name] = module
end

-- Resolve prompt for a mode
function M.resolve_prompt(mode_name, opts)
  if mode_name == 'default' then
    if type(M.default_prompt) == 'function' then
      return M.default_prompt(opts)
    end
    return M.default_prompt or ''
  end

  --mode can be a function or a string or a table with prompt function
  local mode = M.modes[mode_name]
  if mode then
    if mode.prompt then
      return type(mode.prompt) == 'function' and mode.prompt(opts) or mode.prompt
    else
      return type(mode) == 'function' and mode(opts) or mode
    end
  end
end

-- Update system prompt for an existing chat
function M.update_chat_prompt(chat, mode_name)
  if not chat then
    return
  end

  -- Remove existing system prompts with "from_config" tag
  chat.messages = vim.tbl_filter(function(msg)
    return not (msg.role == 'system' and msg.opts and msg.opts.tag == 'from_config')
  end, chat.messages)

  -- Add new system prompt
  local prompt = M.resolve_prompt(mode_name, {
    adapter = chat.adapter,
    language = vim.g.codecompanion_language,
  })

  if prompt ~= '' then
    chat:add_system_prompt(prompt)
  end
end

-- Switch to a new mode
function M.switch_mode(mode_name)
  vim.g.cc_mode = mode_name

  -- Update existing chat if present
  local chat = require('codecompanion.strategies.chat').last_chat()
  if chat then
    M.update_chat_prompt(chat, mode_name)
    vim.notify('Switched to ' .. mode_name .. ' mode')
  end
end

-- Get all available modes
function M.get_modes()
  local mode_list = {}
  -- Add built-in modes
  for name, _ in pairs(M.modes) do
    table.insert(mode_list, {
      name = name,
      prompt = M.resolve_prompt(name, {}),
    })
  end
  return mode_list
end

-- Browse available modes using telescope
function M.browse()
  require('plugins.ai.codecompanion.systemprompts.telescope').browse(M)
end

-- Initialize modes
function M.setup()
  -- add built-in mode to switch to default prompt
  M.register_mode('default', function()
    return M.default_prompt
  end)
  -- add user defined modes
  M.register_mode('edit', require('plugins.ai.codecompanion.systemprompts.edit'))
  M.register_mode('architect', require('plugins.ai.codecompanion.systemprompts.architect'))
end

return M
