local function abbr(lhs, rhs)
  vim.keymap.set('ia', lhs, rhs, { buffer = true })
end

abbr('//', '--')
abbr('const', 'local')
abbr('fi', 'end')
abbr('!=', '~=')
abbr('!==', '~=')
abbr('=~', '~=') -- shell uses `=~`
abbr('===', '==')
