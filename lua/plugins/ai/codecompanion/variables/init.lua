local default_variables = {
  ['buffer'] = {
    opts = {
      -- Always sync the buffer by sharing its "diff"
      -- Or choose "all" to share the entire buffer
      default_params = 'diff',
    },
  },
  ['ls'] = {
    callback = function()
      local handle = io.popen('eza -T --git-ignore')
      if handle then
        local result = handle:read('*a')
        handle:close()
        return result
      else
        return 'Unable to load directory structure.'
      end
    end,
    description = 'Recursively lists the directory and file structure of the current working folder.',
    opts = {
      contains_code = false,
    },
  },
  ['explain terminal error'] = {
    callback = function()
      local overseer = require('overseer')
      local constants = require('overseer.constants')

      ---@type overseer.Task[]
      local failed_tasks = overseer.list_tasks({ status = constants.STATUS.FAILURE })
      local first_failed_task = vim.iter(failed_tasks):last() --- @type overseer.Task | nil

      if first_failed_task then
        local lines = vim.api.nvim_buf_get_lines(first_failed_task.strategy.term.bufnr, 0, -1, false)
        local context = 'Explain the error from the command '
          .. (type(first_failed_task.cmd) == 'table' and first_failed_task.cmd[1] or first_failed_task.cmd)
          .. ':\n'
          .. table.concat(lines, '\n')
          .. '\n\n'

        --- @type CodeCompanion.Chat
        local chat = require('codecompanion').buf_get_chat(vim.api.nvim_get_current_buf())
        chat:add_message({
          role = 'user',
          content = context,
        }, { tag = 'variable', visible = false })
      end
    end,
    description = 'Explain the content of the latest failed task',
    opts = {
      contains_code = false,
    },
  },
}

return default_variables
