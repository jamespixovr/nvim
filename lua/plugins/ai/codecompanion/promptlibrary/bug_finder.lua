return {
  strategy = 'chat',
  description = 'Find potential bugs from the provided diff changes',
  opts = {
    index = 20,
    is_default = false,
    short_name = 'bugs',
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        local question = '<question>\n'
          .. 'Check if there is any bugs that have been introduced from the provided diff changes.\n'
          .. 'Perform a complete analysis and do not stop at first issue found.\n'
          .. 'If available, provide absolute file path and line number for code snippets.\n'
          .. '</question>'

        local branch = '$(git merge-base HEAD origin/develop)...HEAD'
        local changes = 'changes.diff'
        vim.fn.system('git diff --unified=10000 ' .. branch .. ' > ' .. changes)

        --- @type CodeCompanion.Chat
        local chat = require('codecompanion').buf_get_chat(vim.api.nvim_get_current_buf())
        local path = vim.fn.getcwd() .. '/' .. changes
        local id = '<file>' .. changes .. '</file>'
        local lines = vim.fn.readfile(path)
        local content = table.concat(lines, '\n')

        chat:add_message({
          role = 'user',
          content = 'git diff content from ' .. path .. ':\n' .. content,
        }, { reference = id, visible = false })

        chat.references:add({
          id = id,
          path = path,
          source = '',
        })

        return question
      end,
    },
  },
}
