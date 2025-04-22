return {
  name = 'cucumber test',
  desc = 'Run Cucumber tests',
  builder = function()
    -- Get the current line
    local current_line = vim.api.nvim_get_current_line()

    -- Split the line by spaces and find all tags
    local tags = {}
    for word in current_line:gmatch('%S+') do
      if word:match('^@') then
        table.insert(tags, word:sub(2))
      end
    end

    -- Check if we found any tags
    if #tags == 0 then
      vim.notify('No tags found in current line (tags must start with @)', vim.log.levels.ERROR)
      return
    end

    -- Find git root directory
    local function find_git_root()
      local current_dir = vim.fn.expand('%:p:h')
      local git_root =
        vim.fn.systemlist('git -C ' .. vim.fn.shellescape(current_dir) .. ' rev-parse --show-toplevel')[1]
      return git_root
    end

    local git_root = find_git_root()
    if not git_root then
      vim.notify('Not in a git repository', vim.log.levels.ERROR)
      return
    end

    -- Check if it's a Go project (look for go.mod)
    local is_go = vim.fn.filereadable(git_root .. '/go.mod') == 1
    -- Check if it's NPM project (look for package.json)
    local is_npm = vim.fn.filereadable(git_root .. '/package.json') == 1

    if is_go then
      -- Join all tags with commas for the -t argument
      local tag_arg = table.concat(tags, ',')
      return {
        cmd = { 'go' },
        args = { 'test', '-t', tag_arg, '-l', 'local', '--debug' },
        cwd = git_root,
        components = {
          { 'on_output_quickfix', open = false },
          'default',
        },
      }
    elseif is_npm then
      -- Join all tags with ' or ' for cucumber-js
      local tag_expr = table.concat(tags, ' or @')
      return {
        cmd = { 'pnpm' },
        args = { 'cucumber-js', '--tags', '@' .. tag_expr },
        cwd = git_root,
        components = {
          { 'on_output_quickfix', open = false },
          'default',
        },
      }
    else
      vim.notify('Neither Go nor Node.js project detected', vim.log.levels.ERROR)
      return
    end
  end,
  condition = {
    filetype = { 'cucumber' },
  },
}
