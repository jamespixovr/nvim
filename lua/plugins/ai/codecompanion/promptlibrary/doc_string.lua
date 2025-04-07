return {
  strategy = 'inline',
  description = 'Add appropriate documentation to the selected code',
  opts = {
    short_name = 'docstrings',
    auto_submit = true,
  },
  prompts = {
    {
      role = 'system',
      content = function(context)
        return 'You are a senior '
          .. context.filetype
          .. ' developer. You add clear and appropriate documentation based on code context.'
      end,
    },
    {
      role = 'user',
      content = function(context)
        local text = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        return string.format(
          [[
Add appropriate documentation to this code:
- For functions: Add proper docstrings following language conventions, including types if present
- For configuration/script code: Add simple descriptive comments explaining purpose
- Do NOT modify any of the actual code - only add documentation
- Keep any existing documentation style
- Return the complete code with added documentation

```%s
%s
```]],
          context.filetype,
          text
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
