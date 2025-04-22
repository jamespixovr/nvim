local M = {}

function M.home(version)
  local home = nil

  -- Run zsh to execute java_home -V and parse output for given version
  local job_id = vim.fn.jobstart({
    'zsh',
    '-c',
    '/usr/libexec/java_home -V 2>&1 | grep "^ *' .. tostring(version) .. "\" | tail -n1 | awk '{print $NF}'",
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] and data[1] ~= '' then
        home = vim.trim(data[1])
      end
    end,
  })

  vim.fn.jobwait({ job_id })

  return home
end

return M
