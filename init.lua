-- CONFIG
vim.g.borderStyle = 'rounded' ---@type "single"|"double"|"rounded"|"solid"

vim.g.linterConfigs = vim.fs.normalize('~/.config/nvim/.linter-configs/')

-- vim.g.cmploader = 'nvim-cmp' -- blink.cmp, nvim-cmp
vim.g.cmploader = 'blink.cmp' -- blink.cmp, nvim-cmp

vim.g.winborder = 'single'

local enable_border = true

vim.g.border = {
  enabled = enable_border,
  style = enable_border and vim.g.winborder or { ' ' },
  borderchars = enable_border and { '─', '│', '─', '│', '┌', '┐', '┘', '└' }
    or { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
}

require('config')
