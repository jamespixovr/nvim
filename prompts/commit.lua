local function ticket_from_branch()
  local branch = vim.system({ 'git', 'branch', '--show-current' }, { text = true }):wait().stdout
  return vim.trim(branch or ''):match('([A-Z][A-Z0-9]+%-%d+)') or ''
end

return {
  ticket = ticket_from_branch,
  diff = function(args)
    return vim.system({ 'git', 'diff', '--no-ext-diff', '--staged' }, { text = true }):wait().stdout
  end,
}
