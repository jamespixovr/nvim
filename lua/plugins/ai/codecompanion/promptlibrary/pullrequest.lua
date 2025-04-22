return {
  strategy = 'chat',
  description = 'Generate a Pull Request message description',
  opts = {
    index = 18,
    is_default = false,
    short_name = 'pr',
    is_slash_cmd = true,
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        return 'You are an expert at writing detailed and clear pull request descriptions.'
          .. 'Please create a pull request message following standard convention from the provided diff changes.'
          .. 'Ensure the title, description, type of change, checklist, related issues, and additional notes sections are well-structured and informative.'
          .. '\n\n```diff\n'
          .. vim.fn.system('git diff $(git merge-base HEAD main)...HEAD')
          .. vim.fn.system('git diff $(git merge-base HEAD develop)...HEAD')
          .. '\n```'
      end,
    },
  },
}
