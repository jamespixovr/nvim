local M = {}

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
      local act, prompt = line:match('^"?([^,"]+)"?,%s*"?(.+)"?$')
      if act and prompt then
        prompts[act] = prompt
      end
    end
  end
  return prompts
end

function M.load_local_prompts()
  local filelocation = vim.fn.stdpath('config') .. '/gpt_prompt.csv'
  local handle = io.open(filelocation, 'r')
  if not handle then
    return {}
  end

  local prompts = {}
  local first_line = true
  for line in handle:lines() do
    if first_line then
      first_line = false
    else
      -- Parse CSV line with quoted strings possibly containing commas
      local act, prompt = line:match('^"(.-)","(.-)"$')
      if act and prompt then
        -- Unescape inner quotes if needed
        prompt = prompt:gsub('""', '"')
        prompts[act] = prompt
      end
    end
  end
  handle:close()
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

function M.prompt_library()
  local prompt_lists = {}
  local prompts = M.load_local_prompts()

  for act, prompt in pairs(prompts) do
    local shortName = act:match('^(%w+)'):lower()
    prompt_lists[act] = {
      strategy = 'chat',
      description = string.format('Act as an expert %s', act),
      opts = {
        short_name = shortName,
        is_slash_cmd = true,
        auto_submit = false,
        ignore_system_prompt = true,
      },
      prompts = {
        {
          role = 'system',
          content = prompt,
          opts = { visible = true },
        },
        {
          role = 'user',
          content = [[]],
        },
      },
    }
  end

  return prompt_lists
end

function M.prompt_library_online()
  local prompt_lists = {}
  local prompts = M.load_prompts(vim.fn.stdpath('cache') .. '/prompts.json', 86400, true)

  for act, prompt in pairs(prompts) do
    local shortName = act:match('^(%w+)'):lower()
    prompt_lists[act] = {
      strategy = 'chat',
      description = string.format('Act as an expert %s', act),
      opts = {
        short_name = shortName,
        is_slash_cmd = true,
        auto_submit = false,
        ignore_system_prompt = true,
      },
      prompts = {
        {
          role = 'system',
          content = prompt,
          opts = { visible = true },
        },
        {
          role = 'user',
          content = [[]],
        },
      },
    }
  end

  return prompt_lists
end

return M
