---@param chat CodeCompanion.Chat
local function callback(chat)
  local content = string.format([[@cmd_runner
I need you to review a merge request. Your task:
1. Gather diffs via `git diff <branch_merge_to>...<branch_feature>`
2. Review diffs. Notice that:
   - You may need to gather context from other unchanged codes to understand the diffs. You should understand every piece of code in diffs.
   - Correctness, performance and readability are the most important factors
   - Also review the design, architecture and implementation
   - Try your best to dig out potential bugs

- Branch merge to: master
- Branch feature: origin/]]) -- wait for manual input

  chat:add_buf_message({
    role = 'user',
    content = content,
  })
end

return {
  description = 'Fetch git branch and review diff',
  callback = callback,
  opts = {
    contains_code = true,
  },
}
