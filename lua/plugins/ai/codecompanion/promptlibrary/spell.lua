return {
  strategy = 'inline',
  description = 'Correct grammar and reformulate',
  opts = {
    index = 19,
    is_default = false,
    short_name = 'spell',
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      contains_code = false,
      content = function(context)
        local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        return 'Correct grammar and reformulate:\n\n' .. text
      end,
    },
  },
}
