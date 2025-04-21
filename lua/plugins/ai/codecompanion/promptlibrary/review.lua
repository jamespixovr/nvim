return {
  strategy = 'chat',
  description = 'Review the provided code snippet.',
  opts = {
    -- index = 3,
    -- is_default = true,
    modes = { 'v' },
    is_slash_cmd = true,
    short_name = 'review',
    stop_context_insertion = true, -- selected text is already sent
    user_prompt = false, -- user input is not required
    auto_submit = true,
  },
  prompts = {
    {
      role = 'system',
      content = function(context)
        return string.format(
          [[I want you to act as a senior %s developer. Act like you're doing a code review, point out possible mistakes, missed edge cases and suggest improvements. Don't return the whole modified code, only return the parts of the code you have suggestions. Don't send the whole modified code! Each code block with a suggestion should have a comment inline with the code (inside the code block) explaining the change, this comment should have a prefix of "SUGGESTION:".]],
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
      content = function(context)
        local buf_utils = require('codecompanion.utils.buffers')

        return '```' .. context.filetype .. '\n' .. buf_utils.get_content(context.bufnr) .. '\n```\n\n'
      end,
      opts = {
        visible = false,
        contains_code = true,
      },
    },
    {
      role = 'user',
      content = function(context)
        local code = require('codecompanion.helpers.actions').get_code(context.start_line, context.end_line)
        return string.format(
          [[And this is some code that relates to my question:

              ```%s
              %s
              ```
              ]],
          context.filetype,
          code
        )
      end,
      opts = {
        visible = false,
        contains_code = true,
      },
    },
  },
}
