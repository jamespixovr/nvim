
vim.g.neon_style = "dark"
vim.g.neon_italic_keyword = true
vim.g.neon_italic_function = true
vim.g.neon_transparent = true

vim.cmd[[colorscheme neon]]

-- remove the dark background color for the sign column
vim.cmd[[highlight clear SignColumn]] 

