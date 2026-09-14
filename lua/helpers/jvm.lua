local M = {}

--- Resolve the actual JAVA_HOME from a mise install dir.
--- mise installs the macOS JDK bundle, so JAVA_HOME lives in Contents/Home.
local function resolve_home(base)
  if vim.fn.isdirectory(base .. '/Contents/Home') == 1 then
    return base .. '/Contents/Home'
  end
  return base
end

function M.home(version)
  local home = nil

  local mise = vim.fn.exepath('mise')
  if mise == '' then
    return nil
  end

  -- mise where java@<version> prints the install dir for the requested version
  local job_id = vim.fn.jobstart({
    mise,
    'where',
    'java@' .. tostring(version),
  }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and data[1] and data[1] ~= '' then
        home = resolve_home(vim.trim(data[1]))
      end
    end,
  })

  vim.fn.jobwait({ job_id })

  return home
end

return M
