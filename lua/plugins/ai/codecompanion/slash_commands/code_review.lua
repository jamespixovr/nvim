-- https://github.com/petobens/dotfiles/blob/master/nvim/lua/plugin-config/codecompanion_config.lua
-- https://github.com/petobens/llm-prompts/blob/main/md-prompts/code_reviewer.md

local ft_prompt_map = {
  lua = 'lua_role',
  python = 'python_role',
  sh = 'bash_role',
  sql = 'Sql_role',
  tex = 'latex_role',
}
local utils = require('plugins.ai.codecompanion.utils')

local quickfix = [[
You are an expert coder and helpful assistant who can help debug code diagnostics, such as warning and error messages.

You will be provided with:
- A list of code diagnostics (errors and/or warnings) in the following format:
  ```
  /path/to/file.py:line:col: tool: message
  ```
- The full content of the corresponding file(s). There may be multiple files, each with its own diagnostics and content.

Special instructions:
- Sometimes, the same or very similar diagnostic may be reported by different tools (e.g., both mypy and ruff) for the same line of code. In such cases, address the issue only once, grouping the tools together, and avoid unnecessary repetition in your explanations and suggestions.
- If a diagnostic is unclear or the fix is ambiguous, make a best guess and explain your reasoning. If more information is needed, note what is missing.
- When showing code, include enough context (e.g., the full function or class) if it helps clarify the issue, but keep it concise.

Your tasks:
1. For each unique diagnostic (even if reported by multiple tools), explain what the error or warning means in clear, concise language.
2. Point out the relevant line(s) in the corresponding file and, if possible, show the problematic code.
3. Suggest a fix for each issue. If a code change is needed, provide the corrected code as a fenced code block with the appropriate language identifier.
4. If multiple issues are related (even across different files), explain their relationship and suggest a holistic fix if possible.

Format your response as follows:
- For each unique diagnostic:
  - **File:** (file path)
  - **Diagnostic(s):** (list all tools and their messages for this issue)
  - **Explanation:** (what it means)
  - **Relevant Code:** (show the code, if applicable)
  - **Suggested Fix:** (explain and show the fix in a code block)
- If you need to make multiple changes, show the full corrected code for each affected file at the end.

Be thorough, but keep your explanations focused and actionable.

Here is the list of code diagnostics:
```
%s
```
]]

local conventional_commits = [[
Given the following git diff, generate a concise and descriptive commit message.

1. First, analyze the last 50 commit messages in this repository (provided below).
2. If the majority of them follow the Conventional Commits specification, write the new commit message using the Conventional Commits style.
   - Use the correct type (feat, fix, chore, refactor, docs, test, style, perf, build, ci, etc.).
   - Include an optional scope in parentheses if appropriate.
   - Do not include breaking change notation unless the diff clearly indicates a breaking change.
   - **Example:**
     ```text
      fix(ui): prevent session file from being saved in headless or worker instances

      Only save the session file if a UI is attached, avoiding unwanted session writes from
      headless processes such as test workers.
      ```
3. If the majority do **not** follow the Conventional Commits style, instead mimic the style and format of the recent commit history.
   - **Example:**
     ```text
      vim: include recent commit history in codecompanion conventional_commit prompt

      Pass the last 50 commit messages as context to improve the quality of generated conventional commit messages.
     ```
4. If the style is unclear or tied, default to Conventional Commits.

**Important:**
- Output only the commit message, in plain text. Do not include any explanations, code blocks, or extra formatting.
- Keep the commit message under 72 characters if possible.
- Write a short summary in the imperative mood after the colon.
- Optionally, add a longer description after a blank line if more context is needed.

Recent commit history:
```text
%s
```

Git diff:
```diff
%s
```
]]

local code_reviewer = [[
You are a senior software engineer.

Please review the following git diff and provide feedback in the style of a GitHub Copilot code review. Your feedback should be constructive, actionable, and concise.

**Your response must include:**

**1. Overview of Changes**
- Briefly summarize the purpose and main effect of the changes in this diff.

**2. Reviewed Changes**
- List the key areas or files changed and what was updated.

**3. Comments**
- For each significant change, provide bullet-point feedback, including:
  - Code correctness and logic errors
  - Code style and readability
  - Potential bugs or edge cases
  - Suggestions for improvement
  - Performance concerns (if any)
  - Adherence to best practices
  - (Optional) Minor style or documentation nitpicks

- Reference specific lines or code snippets where relevant.
- Use neutral, practical language.
- When making a suggestion for improvement, always provide a concrete code example or snippet that demonstrates your recommendation.

**4. Overall Recommendations**
- Summarize any major issues or next steps for the author.

Here is the git diff:
```diff
%s
```
]]

local ok, codecompanion = pcall(require, 'codecompanion')
if not ok then
  return
end

local function try_focus_chat_float()
  -- Focus window if already open (we search for a floating window with specific zindex)
  for _, win_id in ipairs(vim.api.nvim_list_wins()) do
    local conf = vim.api.nvim_win_get_config(win_id)
    if conf.focusable and conf.relative ~= '' and conf.zindex == 45 then
      vim.api.nvim_set_current_win(win_id)
      return true
    end
  end
  return false
end

local function focus_or_toggle_chat()
  if try_focus_chat_float() then
    return
  end
  codecompanion.toggle()
  vim.defer_fn(function()
    vim.cmd('startinsert')
  end, 1)
end

local function get_or_create_chat()
  local chat = codecompanion.last_chat()
  if not chat then
    chat = codecompanion.chat()
  end
  return chat
end

local function to_absolute_paths(files, root)
  return vim
    .iter(files)
    :map(function(f)
      if f == '' then
        return nil
      end
      local abs_path = vim.fs.normalize(vim.fs.joinpath(root, f))
      if vim.fn.filereadable(abs_path) == 1 then
        return abs_path
      end
      return nil
    end)
    :filter(function(f)
      return f ~= nil
    end)
    :totable()
end

local function add_context(files)
  local chat = get_or_create_chat()
  if not chat then
    return
  end
  for _, file in ipairs(files) do
    local content = table.concat(vim.fn.readfile(file), '\n')
    chat:add_context({
      role = 'user',
      content = string.format('Here is the content of %s:%s', file, content),
    }, 'file', string.format('<file>%s</file>', vim.fn.fnamemodify(file, ':t')))
  end
  focus_or_toggle_chat()
end

local function add_watched_context(files)
  local chat = get_or_create_chat()
  if not chat then
    return
  end

  for _, file in ipairs(files) do
    local expanded = vim.fn.expand(file)
    local bufnr = vim.fn.bufnr(expanded, true)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
      vim.fn.bufload(bufnr)
    end
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), '\n')
      chat:add_context(
        {
          role = 'user',
          content = string.format('Here is the content of %s:%s', expanded, content),
        },
        'buffer',
        string.format('<buf>%s</buf>', vim.fn.fnamemodify(expanded, ':t')),
        {},
        { bufnr = bufnr, opts = { watched = true } }
      )
    else
      vim.notify('Could not load buffer for file: ' .. expanded, vim.log.levels.WARN)
    end
  end
  focus_or_toggle_chat()
end

local function send_project_tree(chat, root)
  local result = vim.system({ 'tree', '-a', '-L', '2', '--noreport', root }, { text = true }):wait()
  local tree = result.stdout or ''
  chat:add_message({
    role = 'user',
    content = string.format('The project structure is given by:\n%s', tree),
  })
end

local function get_loclists_or_qf_entries()
  local diagnostics = {}
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local loclist = vim.fn.getloclist(winid)
    if #loclist > 0 then
      vim.list_extend(diagnostics, loclist)
    end
  end
  if #diagnostics == 0 then
    diagnostics = vim.fn.getqflist()
  end

  local seen, entries, context = {}, {}, {}
  for _, item in ipairs(diagnostics) do
    local filename = vim.fn.fnamemodify(vim.fn.bufname(item.bufnr), ':p')
    local lnum = item.lnum or 0
    local col = item.col or 0
    local text = item.text or ''
    local key = table.concat({ filename, lnum, col, text }, '\0')
    if not seen[key] then
      seen[key] = true
      table.insert(entries, string.format('%s:%d:%d: %s', filename, lnum, col, text))
      if filename ~= '' and not vim.tbl_contains(context, filename) then
        table.insert(context, filename)
      end
    end
  end
  return table.concat(entries, '\n'), context
end

local function get_majority_filetype(files)
  local counts = {}
  local max_ft, max_count = nil, 0
  for _, file in ipairs(files) do
    local ft = vim.filetype.match({ filename = file })
    if ft and ft ~= '' then
      counts[ft] = (counts[ft] or 0) + 1
      if counts[ft] > max_count then
        max_count = counts[ft]
        max_ft = ft
      end
    end
  end
  -- Only return a filetype if it appears in more than half of the files
  if max_count > (#files / 2) then
    return max_ft
  end
  return nil
end

--TODO: break into smaller functions
local M = {
  ['file_path'] = {
    description = 'Insert a filepath',
    keymaps = { modes = { n = '<C-f>', i = '<C-f>' } },
    callback = function()
      vim.ui.input({ prompt = 'File path: ', completion = 'file' }, function(file)
        if not file or vim.fn.filereadable(file) == 0 then
          vim.notify('File not found: ' .. tostring(file), vim.log.levels.ERROR)
          return
        else
          add_context({ file })
        end
      end)
    end,
  },
  ['directory'] = {
    description = 'Insert all files in a directory',
    callback = function(chat)
      vim.ui.input({ prompt = 'Context dir: ', completion = 'dir' }, function(dir)
        dir = vim.fn.trim(vim.fn.fnamemodify(dir, ':ph')):gsub('/$', '')
        vim.cmd('redraw!')
        if vim.fn.isdirectory(dir) == 0 then
          vim.notify('Directory not found: ' .. dir, vim.log.levels.ERROR)
          return
        end
        local glob_result = vim.fn.glob(dir .. '/*', false, true)
        local files = {}
        for _, file in ipairs(glob_result) do
          if vim.fn.isdirectory(file) == 0 then
            table.insert(files, file)
          end
        end
        send_project_tree(chat, dir)
        add_context(files)
      end)
    end,
  },
  ['git_files'] = {
    description = 'Insert all files in git repo',
    callback = function(chat)
      local git_root, err = utils.get_git_root()
      if not git_root then
        vim.notify(err or 'No git repo found', vim.log.levels.ERROR)
        return
      end
      local result = vim.system({ 'git', 'ls-files', '--full-name', git_root }, { text = true }):wait()
      local git_files = vim.split(vim.trim(result.stdout or ''), '\n', { plain = true })

      local ignore_exts = { ['.png'] = true }
      local function has_ignored_ext(filename)
        local ext = filename:match('(%.[^%.]+)$') or ''
        return ignore_exts[ext] or false
      end
      local files = vim.tbl_map(
        function(f)
          return git_root .. '/' .. f
        end,
        vim.tbl_filter(function(f)
          return not has_ignored_ext(f)
        end, git_files)
      )

      send_project_tree(chat, git_root)
      add_context(files)
    end,
  },
  ['conventional_commit'] = {
    description = 'Generate a conventional git commit message',
    callback = function(chat)
      local git_root, err = utils.get_git_root()
      if not git_root then
        vim.notify(err or 'No git repo found', vim.log.levels.ERROR)
        return
      end

      local result = vim.system({ 'git', 'diff', '--cached', '--name-only' }, { text = true }):wait()
      local staged = vim.split(vim.trim(result.stdout or ''), '\n', { plain = true })
      if #staged == 0 or (#staged == 1 and staged[1] == '') then
        vim.notify('No staged changes found', vim.log.levels.WARN)
        return
      end
      local abs_files = to_absolute_paths(staged, git_root)
      add_context(abs_files)

      result = vim.system({ 'git', 'log', '-n', '50', '--pretty=format:%s' }, { text = true }):wait()
      local commit_history = vim.trim(result.stdout or '')

      chat:add_buf_message({
        role = 'user',
        content = string.format(
          conventional_commits,
          commit_history,
          vim.system({ 'git', 'diff', '--no-ext-diff', '--staged' }, { text = true }):wait().stdout
        ),
      })
      chat:submit()
    end,
  },
  ['code_review'] = {
    description = 'Perform a code review',
    callback = function(_, opts)
      local git_root, err = utils.get_git_root()
      if not git_root then
        vim.notify(err or 'No git repo found', vim.log.levels.ERROR)
        return
      end

      local diff_cmd = 'git diff --no-ext-diff '
      local file_list_cmd = 'git diff --name-only '
      if opts and opts.base_branch then
        local base = opts.base_branch
        local result = vim.system({ 'git', 'rev-parse', '--verify', base }, { text = true }):wait()
        if result.code ~= 0 then
          vim.notify('Base branch not found: ' .. base, vim.log.levels.ERROR)
          return
        end
        diff_cmd = diff_cmd .. base .. '...HEAD'
        file_list_cmd = file_list_cmd .. base .. '...HEAD'
      elseif opts and opts.commit_sha then
        local sha = opts.commit_sha
        diff_cmd = diff_cmd .. sha .. '^!'
        file_list_cmd = file_list_cmd .. sha .. '^!'
      else
        diff_cmd = diff_cmd .. '--staged'
        file_list_cmd = file_list_cmd .. '--cached'
      end

      local file_list_args = vim.split(file_list_cmd, ' ', { trimempty = true })
      local file_list_result = vim.system(file_list_args, { text = true }):wait()
      local file_list = vim.split(vim.trim(file_list_result.stdout or ''), '\n', { plain = true })
      if #file_list == 0 or (#file_list == 1 and file_list[1] == '') then
        vim.notify('No relevant files found', vim.log.levels.WARN)
        return
      end
      local abs_files = to_absolute_paths(file_list, git_root)

      -- Determine majority filetype and call the prompt for that filetype
      local ft = get_majority_filetype(abs_files)
      local prompt_alias = ft_prompt_map[ft] or 'assistant_role'
      codecompanion.prompt(prompt_alias)
      -- Since prompt generates a new chat we need to get the new handle
      -- and ignore the one passed as argument
      local chat = get_or_create_chat()
      if not chat then
        return
      end

      -- Use watched context for staged/commit reviews and plain context
      -- for branch diffs
      if opts and opts.base_branch then
        add_context(abs_files)
      else
        add_watched_context(abs_files)
      end

      local diff_args = vim.split(diff_cmd, ' ', { trimempty = true })
      local diff_result = vim.system(diff_args, { text = true }):wait()
      chat:add_buf_message({
        role = 'user',
        content = string.format(code_reviewer, diff_result.stdout),
      })
      chat:submit()
    end,
  },
  ['qfix'] = {
    description = 'Explain quickfix/loclist code diagnostics',
    callback = function(chat)
      local entries, context = get_loclists_or_qf_entries()
      if entries == '' then
        vim.notify('No diagnostics found in quickfix or location lists.', vim.log.levels.ERROR)
        return
      end
      add_context(context)
      chat:add_buf_message({
        role = 'user',
        content = string.format(quickfix, entries),
      })
      chat:submit()
    end,
  },
}

return M
