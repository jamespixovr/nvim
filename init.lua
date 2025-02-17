-- CONFIG
vim.g.borderStyle = 'rounded' ---@type "single"|"double"|"rounded"|"solid"

vim.g.linterConfigs = vim.fs.normalize('~/.config/nvim/.linter-configs/')

-- vim.g.cmploader = 'nvim-cmp' -- blink.cmp, nvim-cmp
vim.g.cmploader = 'blink.cmp' -- blink.cmp, nvim-cmp

require('config')
