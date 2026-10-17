return {
  ['Add documentation to this code or function'] = {
    interaction = 'chat',
    description = 'Create documentation for this code and update the buffer',
    opts = {
      auto_submit = true,
      -- ignore_system_prompt = true,
      is_slash_cmd = true,
      alias = 'document',
      adapter = {
        name = 'copilot',
      },
    },
    prompts = {
      {
        role = 'user',
        content = [[
#{buffer}
@{edit_file}

Add documentation to the selected code or function.
Include argument and return types (but omit types for typescript).
Be succinct.
Do not add comments to variables or single line expressions.
        ]],
      },
    },
  },

  ['Edit Current Buffer'] = {
    interaction = 'chat',
    description = 'Edit the current buffer',
    prompts = {
      {
        role = 'system',
        content = [[You are an experienced developer. You will be requested to make some changes to a provided buffer. Keep
your responses concise and to the point. Don't include next-step suggestions. When the user asks you a question about
the buffer, edit it with your suggestions using your editor tool unless the user asks you to do otherwise.]],
      },
      {
        role = 'user',
        -- content = '@{edit_file} @{cmd_runner} #{buffer} \n\n'
        content = 'Here is the current buffer: #{buffer}\n\nUsing your @{edit_file} and @{run_command} tool, make the following change(s):\n\n',
      },
    },
    opts = {
      auto_submit = false,
      alias = 'edit',
      is_slash_cmd = true,
    },
  },
}
