-- If available, open the last chat, otherwise open a new chat
local function open_chat()
  local chat = require('codecompanion.interactions.chat').last_chat()
  if chat then
    chat.ui:open()
    vim.api.nvim_set_current_win(chat.ui.winnr)
  else
    vim.cmd('CodeCompanionChat')
  end
end

local REVIEW_PROMPT =
  "Please answer users's question with their language. For edit requests, please collect them in the very end and ask if user want to edit them.\n\n#{code_review}"

---Put the pending review comments into the chat via the code_review editor context
---@param opts? { submit?: boolean }
local function send_review(opts)
  opts = opts or {}

  local cc = require('codecompanion')
  local chat = cc.last_chat() or cc.chat()
  chat.ui:open()
  chat:add_buf_message({ role = 'user', content = REVIEW_PROMPT })

  if opts.submit ~= false then
    chat:submit()
  end
end

-- Smart Inline
--
-- Handle <leader>c mapping intelligently based on selection state.
-- No selection: Start with current file context
-- With selection: Use range-based CodeCompanion
local function smart_inline()
  local mode = vim.api.nvim_get_mode().mode
  local has_snacks = pcall(require, 'snacks.input')

  if has_snacks then
    -- Use snacks input
    if mode == 'n' then
      vim.ui.input({ prompt = 'CodeCompanion: ' }, function(input)
        if input and input ~= '' then
          vim.cmd('CodeCompanion #{buffer} ' .. input)
        end
      end)
    else
      vim.ui.input({ prompt = 'CodeCompanion: ' }, function(input)
        if input and input ~= '' then
          vim.cmd("'<,'>CodeCompanion " .. input)
        end
      end)
    end
  else
    -- Fallback to command line
    local prefix = mode == 'n' and ':CodeCompanion #{buffer} ' or ':CodeCompanion '
    vim.fn.feedkeys(prefix, 'n')
  end
end

local function ask_selection()
  vim.ui.input({ prompt = 'CodeCompanion Input: ' }, function(input)
    if not input then
      return
    end

    CodeCompanion = require('codecompanion')
    local prompt = input and '<prompt>\n' .. input .. '\n</prompt>' or ''
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 })
    local buffer_reference = '#{buffer}'
    local lines = vim.fn.getline(vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2])
    local text = ''
    if #lines ~= 0 then
      text = '```' .. filetype .. '\n' .. table.concat(lines, '\n') .. '\n```'
    end

    local content = '@{insert_edit_into_file}\n'
      .. buffer_reference
      .. '\n'
      .. text
      .. '\n'
      .. prompt
      .. '\nApply the changes directly to the file if requested.'

    local chat = CodeCompanion.last_chat()
    if not chat then
      chat = CodeCompanion.chat()
    end

    chat:add_buf_message({
      role = 'user',
      content = content,
    })
    chat:submit()
    -- chat.ui:hide()
  end)
end

local function send_buffer_to_chat(bufnr)
  CodeCompanion = require('codecompanion')

  local chat = CodeCompanion.last_chat()
  if not chat then
    chat = CodeCompanion.chat()
  end

  chat:add_buf_message({
    role = 'user',
    content = '#{buffer:' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t') .. '}',
  })
  chat.ui:open()
end

return {
  {
    'ga',
    '<cmd>CodeCompanionChat Add<cr>',
    mode = { 'v' },
    desc = 'Add selection to CodeCompanionChat',
    silent = true,
  },
  {
    '<leader>at',
    -- '<cmd>CodeCompanionChat Toggle<CR>',
    function()
      if vim.o.columns < 100 then
        return require('codecompanion').toggle({ window_opts = { layout = 'float', width = vim.o.columns } })
      end
      require('codecompanion').toggle({ window_opts = { layout = 'vertical' } })
    end,

    desc = 'CodeCompanion Toggle',
    mode = { 'n', 'v' },
    silent = true,
  },
  { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' }, silent = true },
  { '<leader>ad', ':CodeCompanionChat adapter=deepseek<CR>', desc = 'Codecompanion DeepSeek', silent = true },
  { '<leader>an', ':CodeCompanionChat adapter=anthropic<CR>', desc = 'Codecompanion Anthropic', silent = true },
  { '<leader>ao', ':CodeCompanionChat adapter=openai<CR>', desc = 'Chat with OpenAI', silent = true },
  { '<leader>ac', ':CodeCompanionChat adapter=copilot<CR>', desc = 'Chat with Copilot', silent = true },
  { '<leader>au', ':CodeCompanionChat adapter=openrouter<CR>', desc = 'Codecompanion OpenRouter', silent = true },
  { '<leader>aq', ':CodeCompanionChat adapter=qwen<CR>', desc = 'Codecompanion Qwen', silent = true },
  -- { '<Leader>ah', '<Cmd>CodeCompanionHistory<CR>', desc = 'AI: Show chat history', silent = true },
  { '<leader>arc', '<cmd>CodeCompanionCodeReview Comment<cr>', mode = { 'n', 'v' }, desc = 'Comment on lines' },
  { '<leader>ars', '<cmd>CodeCompanionCodeReview Start<cr>', mode = 'n', desc = 'Start code review' },
  {
    '<leader>arl',
    '<cmd>CodeCompanionCodeReview Comments<cr>',
    mode = 'n',
    desc = 'Edit review comments file',
  },

  { '<leader>ai', ask_selection, mode = { 'n', 'v' }, desc = 'Code Companion Inline Prompt', silent = true },
  {
    '<leader>as',
    smart_inline,
    mode = { 'n', 'v' },
    desc = 'CodeCompanion Smart Inline',
    silent = true,
    noremap = true,
  },
  { '<Leader>ae', open_chat, desc = '[A]I CodeCompanion [c]hat', silent = true },
  { '<leader>al', ':CodeCompanionCLI<CR>', desc = 'Open Claude Code', silent = true },
  { '<leader>aC', ':CodeCompanionCLI agent=codex<CR>', desc = 'Open Codex', silent = true },
  {
    '<leader>aw',
    '<cmd>CodeCompanionChat /write-tests<CR>',
    mode = 'v',
    desc = 'Generate Tests (CodeCompanion)',
    silent = true,
  },
  {
    '<Leader>ap',
    function()
      return require('codecompanion').cli({ prompt = true })
    end,
    mode = { 'n', 'v' },
    desc = 'Prompt the CLI agent',
    silent = true,
  },
  {
    '<leader>ab',
    function()
      send_buffer_to_chat(vim.api.nvim_get_current_buf())
    end,
    desc = 'Code Companion Send Buffer',
  },
  {
    '<leader>ax',
    ':CodeCompanion #{explain terminal error}<cr>',
    mode = { 'n' },
    desc = 'Code Companion Explain Terminal Error',
  },
  {
    '<leader>am',
    function()
      vim.ui.input({ prompt = 'Message: ' }, function(msg)
        if not msg or msg == '' then
          return
        end
        local escaped = vim.fn.escape(msg, '"')
        vim.cmd([[silent '<,'>CodeCompanionChat ]] .. escaped)
      end)
    end,
    mode = 'v',
    desc = 'CodeCompanion Send Selection with Message',
  },
  {
    '<leader>ars',
    function()
      send_review()
    end,
    mode = 'n',
    desc = 'Submit review comments to chat',
  },
  {
    '<leader>arS',
    function()
      send_review({ submit = false })
    end,
    mode = 'n',
    desc = 'Add review comments to chat (edit before sending)',
  },
  {
    '<leader>arq',
    function()
      if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
        return vim.cmd('cclose')
      end

      local comments = require('codecompanion.interactions.code_review').pending()
      if #comments == 0 then
        return vim.notify('No pending review comments', vim.log.levels.WARN)
      end

      local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
      local items = vim.tbl_map(function(c)
        return {
          filename = (git_root and git_root ~= '') and (git_root .. '/' .. c.path) or c.path,
          lnum = c.start_line,
          end_lnum = c.end_line,
          text = c.comment,
        }
      end, comments)

      vim.fn.setqflist({}, ' ', { title = 'Review Comments', items = items })
      vim.cmd('copen')
    end,
    mode = 'n',
    desc = 'List review comments in quickfix',
  },
  -- [C]odeCompanion [D]iagnostics
  vim.keymap.set('n', '<LocalLeader>cd', function()
    return require('codecompanion').cli('#{diagnostics} Can you fix these?', { focus = false, submit = true })
  end, { desc = 'Send diagnostics to CLI agent' }),
  -- [C]odeCompanion [A]dd
  vim.keymap.set({ 'n', 'v' }, '<LocalLeader>aT', function()
    return require('codecompanion').cli('#{this}', { focus = false })
  end, { desc = 'Add context to the CLI agent' }),
  {
    '<leader>acs',
    function()
      local start_line = vim.fn.line('v')
      local end_line = vim.fn.line('.')
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end
      local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
      local ref = string.format('@%s:%d-%d', path, start_line, end_line)
      vim.api.nvim_input('<Esc>')

      local chat = require('codecompanion').last_chat()
      if chat == nil then
        chat = require('codecompanion').chat({ context = { is_visual = false } })
      end
      if chat and chat.ui and not chat.ui:is_visible() then
        chat.ui:open()
      end
      vim.schedule(function()
        if chat and chat.ui and chat.ui.winnr then
          vim.api.nvim_set_current_win(chat.ui.winnr)
          vim.cmd('normal! G$')
        end
        vim.api.nvim_put({ ref .. ' ' }, 'c', true, true)
        vim.cmd('startinsert!')
      end)
    end,
    mode = 'v',
    desc = 'Send file:line reference to CodeCompanion Chat',
  },
}
