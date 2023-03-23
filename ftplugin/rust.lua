local kmap = vim.keymap.set
kmap('n', '<Leader>rt', ':RustTest<CR>', { buffer = true })
kmap('n', '<LocalLeader>p', ':RustFmt<CR>', { buffer = true })
vim.cmd(':compiler cargo')
