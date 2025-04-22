-- https://github.com/stevearc/overseer.nvim/blob/master/doc/tutorials.md#build-a-c-file
return {
  name = 'run script',
  builder = function()
    local file = vim.fn.expand('%:p')
    local cmd = { file }
    if vim.bo.filetype == 'go' then
      cmd = { 'go', 'run', file }
    elseif vim.bo.filetype == 'lua' then
      cmd = { 'lua', file }
    end
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
    filetype = { 'sh', 'python', 'go', 'lua' },
  },
}
