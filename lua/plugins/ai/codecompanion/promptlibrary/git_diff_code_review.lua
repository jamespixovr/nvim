return {
  strategy = 'chat',
  description = 'Git Diff Code Review',
  opts = {
    is_slash_cmd = true,
    short_name = 'diff_review',
    stop_context_insertion = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      content = function()
        return string.format(
          [[I want you to act as a senior developer. Act like you're doing a code review, point out possible mistakes, missed edge cases and suggest improvements. Be short and concise. If the code does not have issues, do not return it. Add the filename and line. Each code block with a suggestion should have a comment inline with the code (inside the code block) explaining the change, this comment should have a prefix of "SUGGESTION:"
         ```diff
         %s
         ```
         ]],
          vim.fn.system('git changes')
        )
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
