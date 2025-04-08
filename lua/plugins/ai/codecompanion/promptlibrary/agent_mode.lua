return {
  strategy = 'chat',
  description = 'Agent mode with explicit set of tools',
  opts = {
    index = 21,
    is_default = false,
    short_name = 'agent',
    is_slash_cmd = true,
    auto_submit = false,
  },
  prompts = {
    {
      role = 'user',
      contains_code = true,
      content = function()
        return ([[
            You are in agent mode:
            Use tools to answer user request using @full_stack_dev
             - Perform pattern search using `rg --no-heading --line-number --ignore-case`
             - Find the path of a file using `fd`
          ]]):gsub('^ +', '', 1):gsub('\n +', '\n')
      end,
    },
  },
}
