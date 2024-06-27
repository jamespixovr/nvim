require("config")

-- CONFIG
vim.g.borderStyle = "rounded" ---@type "single"|"double"|"rounded"|"solid"

vim.g.linterConfigs = vim.fs.normalize("~/.config/nvim/.linter-configs/")
