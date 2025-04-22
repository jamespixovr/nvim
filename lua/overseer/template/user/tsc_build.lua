local javascript_aliases = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' }
local overseer = require('overseer')

local task_name = 'vscode-tasks-tsc-build'

return {
  name = task_name,
  builder = function()
    return {
      cmd = { 'pnpm', 'tsc' },
      components = {
        { 'on_output_parse', problem_matcher = '$tsc' },
        'on_result_diagnostics',
        'on_result_diagnostics_quickfix',
        'default',
      },
    }
  end,
  tags = { overseer.TAG.BUILD },
  condition = {
    filetype = javascript_aliases,
  },
}
