vim.keymap.set('n', '<leader>td', function()
  require('neotest').run.run({ suite = false, strategy = 'dap' })
end, { buffer = true, desc = 'Debug Nearest (Go)' })
