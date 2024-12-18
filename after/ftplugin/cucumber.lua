-- keys = {
-- { '<leader>ty', '<cmd>Pixovr lifecycle<cr>', desc = 'System [T]est [L]ifecycle' },
-- },
vim.keymap.set(
  'n',
  '<leader>td',
  '<cmd>Pixovr debug<cr>',
  { buffer = true, desc = 'System [T]est [D]ebug', nowait = true }
)

vim.keymap.set(
  'n',
  '<leader>tn',
  '<cmd>Pixovr lifecycle<cr>',
  { buffer = true, desc = 'System [T]est [L]ifecycle', nowait = true }
)
