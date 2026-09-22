vim.loader.enable()

-- require('vim._extui').enable({
--   msg = {
--     target = 'msg',
--     timeout = 4000,
--   },
-- })

vim.g.borderStyle = 'rounded' ---@type "single"|"double"|"rounded"|"solid"

vim.g.cmploader = 'blink.cmp' -- blink.cmp, nvim-cmp

vim.g.winborder = 'single' --[[@as "rounded"|"single"|"double"|"solid"]]

local enable_border = true

vim.g.border = {
  enabled = enable_border,
  style = enable_border and vim.g.winborder or { ' ' },
  borderchars = enable_border and { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    or { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
}
-- builtin plugins
vim.cmd('packadd nvim.undotree')
vim.cmd('packadd nvim.difftool')

require('helpers.global')

require('config')
