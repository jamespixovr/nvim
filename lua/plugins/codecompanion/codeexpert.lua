local M = {}

function M.codeexpert()
  return {
    ['Code Expert'] = {
      strategy = 'chat',
      description = 'Get some special advice from an LLM',
      opts = {
        mapping = '<LocalLeader>ce',
        modes = { 'v' },
        slash_cmd = 'expert',
        auto_submit = true,
        stop_context_insertion = true,
        user_prompt = true,
      },
      prompts = {
        {
          role = 'system',
          content = function(context)
            return 'I want you to act as a senior '
              .. context.filetype
              .. ' developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples.'
          end,
        },
        {
          role = 'user_header',
          contains_code = true,
          content = function(context)
            local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

            return 'I have the following code:\n\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
          end,
        },
      },
    },
  }
end

return M
