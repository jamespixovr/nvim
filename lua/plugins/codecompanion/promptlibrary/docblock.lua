return {
  strategy = 'inline',
  description = 'Add a docblock to the selected code',
  opts = {
    -- index = 3,
    -- is_default = true,
    is_slash_cmd = true,
    short_name = 'doc',
    user_prompt = false,
  },
  prompts = {
    {
      role = 'system',
      content = function(context)
        return string.format(
          [[ I want you to act as a senior %s developer.
                    Write a docblock for the selected code.
                    If it's typescript, for classes don't add any comments for the constructor, just add comments for the class itself.
                    Return only the code with the docblock.]],
          context.filetype
        )
      end,
      opts = {
        visible = false,
        tag = 'system_tag',
      },
    },
    {
      role = 'user',
      condition = function(context)
        return context.is_visual
      end,
      content = function(context)
        local selection = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)

        return string.format(
          [[And this is some code that relates to my question:

```%s
%s
```
]],
          context.filetype,
          selection
        )
      end,
      opts = {
        contains_code = true,
        visible = true,
        tag = 'visual',
      },
    },
  },
}
