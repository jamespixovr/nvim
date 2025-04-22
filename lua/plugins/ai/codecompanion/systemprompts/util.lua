local M = {}

-- Helper function to get formatted time
function M.get_formatted_time()
  return os.date('%m/%d/%Y, %I:%M:%S %p (UTC%z)')
end

-- Helper to get OS info
function M.get_os_info()
  local sysname = vim.loop.os_uname().sysname:lower()
  local release = vim.loop.os_uname().release
  return sysname, release
end

-- Helper to get environment info
function M.get_env_info()
  local sysname, release = M.get_os_info()
  local shell = os.getenv('SHELL') or '/bin/bash'
  local time = M.get_formatted_time()
  local cwd = vim.fn.getcwd()
  local nvim_version = vim.version()

  return {
    os = string.format('%s %s', sysname, release),
    shell = shell,
    time = time,
    cwd = cwd,
    nvim_version = string.format('%s.%s.%s', nvim_version.major, nvim_version.minor, nvim_version.patch),
  }
end

return M
