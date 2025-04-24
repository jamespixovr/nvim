return {
  strategy = 'chat',
  description = 'Generate a commit message to match the Conventional Commit specification',
  opts = {
    index = 10,
    is_default = true,
    is_slash_cmd = true,
    short_name = 'pcommit',
    auto_submit = true,
    adapter = {
      name = 'openai',
      -- model = "claude-3-7-sonnet-20250219",
      -- model = 'claude-3-5-haiku-20241022',
    },
  },
  prompts = {
    {
      role = 'user',
      content = function()
        -- Check for staged changes
        if vim.fn.system('git diff --staged') == '' then
          vim.notify(
            'Error while generating commit message: No staged changes found'
              .. '\n\n'
              .. 'Please stage your changes before running this command.',
            vim.log.levels.ERROR
          )

          return nil
        end

        -- Get current branch
        local current_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('%s+', '')
        -- Get last 5 commit messages from the current branch itself
        local commit_messages = vim.fn.system("git log -n 10 --format='%s%n%b' HEAD 2>/dev/null")
        if commit_messages:match('fatal') then
          commit_messages = vim.fn.system("git log -10 --format='%s%n%b' 2>/dev/null")
        end

        -- Construct initial prompt template
        local template = 'You are an expert at following the Conventional Commit specification.'
          .. 'Given the git diff listed below, please generate a detailed commit message for me and return it to me directly without explanation:'
          .. 'Use the summary line to describe the overall change, followed by an empty line, and then a more detailed, concise description of the change in the body in bullet points.'
          .. 'Keep in mind that the summary line should not exceed 72 characters.'
          .. 'If you encounter variable names or other code elements, please wrap them in backticks.'
          .. 'Consider the path of files changed for scope determination.'

        if commit_messages ~= '' and not commit_messages:match('fatal') then
          template = template
            .. '\n\nPrevious commits in this feature branch (most recent first):'
            .. '\n```\n'
            .. commit_messages
            .. '\n```'
            .. '\nPlease ensure the new commit message is consistent with and builds upon these previous commits.'
        end

        -- Append changes to commit
        template = template .. '\n\nChanges to commit:' .. '\n```\n' .. vim.fn.system('git diff --cached') .. '\n```'

        -- Determine the issue ID prefix
        local issue_id = string.match(current_branch, '^bcd%-(%d%d%d%d)')
        if issue_id then
          template = template
            .. '\n\nPlease prefix the summary line with the following issue ID: BCD-'
            .. issue_id
            .. '\n\nExample: BCD-'
            .. issue_id
            .. ' feat: some new feature'
        end

        -- Check for PLATFORM branch format
        local platform_issue_id = string.match(current_branch, 'PLATFORM%-(%d+)')
        if platform_issue_id then
          template = template
            .. '\n\nPlease prefix the summary line with the following issue ID: PLATFORM-'
            .. platform_issue_id
            .. '\n\nExample: PLATFORM-'
            .. platform_issue_id
            .. ' feat: some new feature'
        end

        return template
      end,
      opts = {
        contains_code = true,
      },
    },
  },
}
