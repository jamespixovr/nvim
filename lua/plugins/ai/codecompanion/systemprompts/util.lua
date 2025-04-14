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

-- Function to fetch and parse CSV from URL
function M.fetch_prompts()
  local url = 'https://raw.githubusercontent.com/f/awesome-chatgpt-prompts/refs/heads/main/prompts.csv'
  local handle = io.popen(string.format('curl -s "%s"', url))
  if not handle then
    return {}
  end

  local result = handle:read('*a')
  handle:close()

  local prompts = {}
  -- Skip header line and parse CSV
  for line in result:gmatch('[^\r\n]+') do
    if not line:match('^act,prompt') then -- Skip header
      local act, prompt = line:match('^"(.-)","(.-)"$')
      if act and prompt then
        prompts[act] = prompt
      end
    end
  end
  return prompts
end

-- Load prompts from cache or fetch new ones
function M.load_prompts(cache_file, cache_expiry, keep_prompts_uptodate)
  local stat = vim.loop.fs_stat(cache_file)
  local needs_update = true
  local prompts = {}

  if stat then
    local current_time = os.time()
    if current_time - stat.mtime.sec < cache_expiry or not keep_prompts_uptodate then
      -- Cache is still valid
      local file = io.open(cache_file, 'r')
      if file then
        local content = file:read('*a')
        file:close()
        local ok, cached = pcall(vim.json.decode, content)
        if ok and cached then
          prompts = cached
          needs_update = false
        end
      end
    end
  end

  if needs_update and keep_prompts_uptodate then
    prompts = M.fetch_prompts()
    -- Save to cache
    local file = io.open(cache_file, 'w')
    if file then
      file:write(vim.json.encode(prompts))
      file:close()
    end
  end

  return prompts
end

return M
