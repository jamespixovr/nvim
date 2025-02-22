vim.cmd.compiler('tsc')
vim.opt_local.makeprg = 'pnpm dlx tsc --noEmit'

local function abbr(lhs, rhs)
  vim.keymap.set('ia', lhs, rhs, { buffer = true })
end

abbr('cosnt', 'const')
abbr('local', 'const')
abbr('--', '//')
abbr('~=', '!==')
abbr('elseif', 'else if')

-- vim.bo.commentstring = "// %s" -- add space
