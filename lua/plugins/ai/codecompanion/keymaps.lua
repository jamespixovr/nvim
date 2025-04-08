return {
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
  {
    '<leader>aa',
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      local name = require('codecompanion').last_chat().references:make_id_from_buf(bufnr)
      if name == '' then
        name = 'Buffer ' .. bufnr
      end
      local id = '<buf>' .. name .. '</buf>'

      require('codecompanion').last_chat().references:add({
        bufnr = bufnr,
        id = id,
        source = 'codecompanion.strategies.chat.variables.buffer',
        opts = {
          watched = true,
        },
      })
      vim.print('buffer added to chat')
    end,
    silent = true,
    desc = 'buffer to CodeCompanion chat',
  },
  { '<leader>ap', ':CodeCompanion /pr<cr>', mode = { 'n' }, desc = 'Code Companion PR' },
  { '<leader>ar', ':CodeCompanion /optimize<cr>', mode = { 'v' }, desc = 'Code Companion Refactor' },
  { '<leader>as', ':CodeCompanion /spell<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Spell' },
  { '<leader>ac', ':CodeCompanion /scommit<cr>', mode = { 'n', 'v' }, desc = 'Code Companion Commit' },
}
