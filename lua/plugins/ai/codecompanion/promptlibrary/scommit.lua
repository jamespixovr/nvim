return {
  strategy = 'inline',
  description = 'staged file commit messages',
  opts = {
    index = 15,
    is_default = false,
    is_slash_cmd = true,
    short_name = 'scommit',
    auto_submit = true,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        return 'You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:'
          .. '\n\n```diff\n'
          .. vim.fn.system('git diff --staged')
          .. '\n```'
      end,
    },
  },
}
