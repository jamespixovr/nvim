local javascript_aliases = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact' }
local typescript_provider = require('overseer.template.vscode.provider.typescript')

return {
  name = 'tsc --watch',
  builder = function()
    local tsconfig = vim.fs.find('tsconfig.json', {
      stop = vim.fn.getcwd() .. '/..',
      type = 'file',
      upward = true,
      path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
    })

    return {
      cmd = { 'pnpm', 'tsc' },
      -- cmd = { 'pnpx', 'tsc', '--watch' },
      components = {
        {
          'on_output_parse',
          problem_matcher = '$tsc-watch',
        },
        'default',
        'on_result_notify',
        'on_result_diagnostics',
        -- 'on_complete_restart',
      },
    }
  end,
  condition = {
    filetype = javascript_aliases,
  },
}
