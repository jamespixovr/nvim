return {
  strategy = 'chat',
  description = 'Explain the architecture of the code',
  prompts = {
    {
      role = 'system',
      content = function(context)
        return [[You are an expert solution architect skilled at explaining complex code in a clear and concise manner. Break down the explanation into logical components and highlight key concepts. Always reply to the user in ]]
          .. context.filetype
      end,
    },
    {
      role = 'user_header',
      contains_code = true,
      condition = function(context)
        return context.is_visual
      end,
      content = function(context)
        local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        return '\n```' .. context.filetype .. '\n' .. text .. '\n```\n\n'
      end,
    },
    {
      role = 'user',
      content = 'Please explain the architecture of the following code:',
    },
  },
}
