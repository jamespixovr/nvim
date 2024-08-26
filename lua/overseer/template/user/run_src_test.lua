return {
  name = 'run src test',
  builder = function()
    -- get the root folder where .git exists

    --
    -- local file = vim.fn.expand('%:p')
    local cmd = { 'go', 'test', '-failfast', './...' }
    return {
      cmd = cmd,
      components = {
        { 'on_output_quickfix', set_diagnostics = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'go' },
  },
}
