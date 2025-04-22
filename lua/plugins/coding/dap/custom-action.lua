local M = {}

function M.attach_to_remote_debugger()
  local filetype = vim.api.nvim_buf_get_option(0, 'filetype')

  if filetype == 'java' then
    vim.ui.input({
      prompt = 'Enter JVM Debug Port',
      default = '5005',
    }, function(input)
      local port = tonumber(input)

      require('dap').run({
        type = 'java',
        request = 'attach',
        name = 'Debug (Attach) - Remote',
        hostName = '127.0.0.1',
        port = port,
      })
    end)
  end
end

return M
