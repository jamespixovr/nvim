-- local function open_file_under_cursor_in_picker()
--   local target = vim.fn.expand('<cfile>')
--   vim.api.nvim_command('wincmd k')
--
--   require('snacks.picker').files({
--     prompt = '🍪 ',
--     default_text = target,
--     wrap = true,
--     find_command = { 'rg', '--files', '--no-require-git' },
--   })
-- end
--
-- vim.keymap.set('n', 'gs', open_file_under_cursor_in_picker, { desc = 'Search file name under cursor' })

local function find_recent_files()
  -- Use smart() which combines recent files, buffers and files (similar to smart_open)
  require('snacks.picker').smart({
    multi = { 'files' },
    format = 'file',
    prompt = '🍪 ',
    wrap = true,
    matcher = {
      fuzzy = true,
      filename_bonus = true,
      history_bonus = true,
      sort_empty = true,
      frecency = true,
    },
    keys = {
      '<leader>q',
      Snacks.picker.qflist,
      desc = 'Add to quickfix list',
    },
    filter = {
      cwd = true,
    },
  })
end
return function()
  return {
    -- { '<leader>.', function() Snacks.scratch() end, desc = 'Toggle Scratch Buffer', },
    {
      '<leader>.',
      function()
        vim.ui.input({
          prompt = 'Enter filetype for the scratch buffer: ',
          default = 'markdown',
          completion = 'filetype',
        }, function(ft)
          require('snacks').scratch.open({
            ft = ft,
            win = {
              width = 200,
              height = 100,
              title = 'Scratch Buffer',
            },
          })
        end)
      end,
      { desc = 'Toggle Scratch Buffer' },
    },
    {
      '<leader>lt',
      function()
        local git_root = vim.fs.root(0, '.git')
        if git_root then
          local file = git_root .. '/todo.md'
          require('snacks').scratch.open({
            ft = 'markdown',
            file = file,
          })
        end
      end,
      desc = 'Toggle Scratch Todo',
    },
    {
      '<leader>st',
      function()
        Snacks.scratch({ icon = ' ', name = 'Todo', ft = 'markdown', file = 'scratch-file.md' })
      end,
      desc = 'Todo List',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>ns',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete current buffer without quitting window',
      mode = { 'n' },
    },
    {
      '<leader>bD',
      function()
        Snacks.bufdelete.other({})
      end,
      desc = 'Delete all buffer except current one without quitting window',
      mode = { 'n' },
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    {
      '<c-\\>',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      ']r',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[r',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>/',
      function()
        ---@class snacks.picker.grep.Config: snacks.picker.proc.Config
        local opts = {
          hidden = false, -- do not include hidden files
          ignored = false, -- true = include files from .gitignore
          exclude = { '*.pb.go', '.venv/*', '.mypy_cache/*', '.repro/*', 'node_modules/*' },
        }
        Snacks.picker.grep(opts)
      end,
      desc = 'Grep',
    },
    {
      '<leader>bg',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>iv',
      function()
        require('snacks').picker.help()
      end,
      desc = '󰋖 Vim help',
    },
    {
      '<leader>ik',
      function()
        require('snacks').picker.keymaps()
      end,
      desc = '󰌌 Keymaps (global)',
    },
    {
      '<leader>iK',
      function()
        require('snacks').picker.keymaps({ global = false, title = '󰌌 Keymaps (buffer)' })
      end,
      desc = '󰌌 Keymaps (buffer)',
    },
    {
      '<leader>rr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>je',
      function()
        Snacks.picker.explorer()
      end,
      desc = 'Explorer',
    },
    {
      '<leader>ff',
      function()
        find_recent_files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>fg',
      function()
        if Snacks.git.get_root() then -- if cwd is git directory
          Snacks.picker.git_files({ -- show files in git root
            untracked = true,
          })
        else
          Snacks.picker.files({ -- show files in cwd
            hidden = true,
            ignored = true,
          })
        end
      end,
      desc = 'Show files in git dir or cwd',
      mode = { 'n' },
    },
    {
      '<leader>fl',
      function()
        Snacks.picker.git_log_file()
      end,
      desc = 'Show git logs of current file',
      mode = { 'n' },
    },
    {
      '<leader>fL',
      function()
        Snacks.picker.git_log()
      end,
      desc = 'Show git logs of git directory',
      mode = { 'n' },
    },

    {
      '<leader>fG',
      function()
        Snacks.picker.grep({
          regex = false,
          show_empty = false,
          live = false, -- It seems live search cannot give "or" result
          supports_live = true,
          need_search = false,
          dirs = { Snacks.git.get_root() or vim.fn.getcwd() },
          search = function(picker)
            if picker.visual then -- if current mode is visual mode
              return picker:word() -- search the visual word
            else
              return '' -- if normal mode, empty search
            end
          end,
        })
      end,
      desc = 'Show grep result under root',
      mode = { 'n', 'v' },
    },
    {
      '<leader>fe',
      function()
        local buf_path = vim.api.nvim_buf_get_name(0)
        local dir = vim.fn.fnamemodify(buf_path, ':h')

        Snacks.picker.files({
          cwd = dir,
          hidden = false,
          ignored = false,
        })
      end,
      desc = 'Find files in current directory',
    },
    {
      '<leader>bb',
      function()
        Snacks.picker.buffers({ layout = { preset = 'select' } })
      end,
      desc = 'Buffers',
    },
    {
      '<leader>sp',
      function()
        Snacks.picker({ layout = { preset = 'vscode' } })
      end,
      desc = 'Pickers',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
    {
      '<leader>sl',
      function()
        require('plugins.snacks.utils.picker-helper').neovim_logs()
      end,
      desc = '[s]earch [l]ogs',
    },
    -- git
    {
      '<leader>gdp',
      function()
        Snacks.picker.git_diff()
      end,
      desc = 'Git Diff (hunks)',
    },
    {
      '<leader>gdo',
      function()
        Snacks.picker.git_diff({ base = 'origin', group = true })
      end,
      desc = 'Git Diff (origin)',
    },
    {
      '<leader>gds',
      function()
        Snacks.picker.git_status()
      end,
      desc = 'Git Status',
    },
    {
      '<leader>gdi',
      function()
        Snacks.picker.gh_issue()
      end,
      desc = 'GitHub Issues (open)',
    },
    {
      '<leader>gdI',
      function()
        Snacks.picker.gh_issue({ state = 'all' })
      end,
      desc = 'GitHub Issues (all)',
    },
    {
      '<leader>gdr',
      function()
        Snacks.picker.gh_pr()
      end,
      desc = 'GitHub Pull Requests (open)',
    },
    {
      '<leader>gdP',
      function()
        Snacks.picker.gh_pr({ state = 'all' })
      end,
      desc = 'GitHub Pull Requests (all)',
    },
    {
      '<leader>uP',
      function()
        Snacks.terminal.toggle(nil, { win = { position = 'bottom' } })
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>up',
      function()
        Snacks.terminal.toggle(nil, { win = { position = 'bottom' } })
      end,
      desc = 'Toggle Terminal',
    },
    {
      '<leader>sgh',
      function()
        require('plugins.snacks.utils.picker-git').git_history()
      end,
      desc = 'Search Git History',
    },
    {
      '<leader>fw',
      function()
        Snacks.picker.grep({
          title = vim.fs.basename(vim.g.use_git_root and vim.fs.root(0, '.git') or vim.uv.cwd()),
          cwd = vim.g.use_git_root and vim.fs.root(0, '.git') or vim.uv.cwd(),
        })
      end,
      desc = 'Picker: Grep',
    },
    {
      '<leader>fs',
      function()
        if not vim.g.roslyn_nvim_selected_solution then
          return vim.notify('No solution file found')
        end

        local projects = require('roslyn.sln.api').projects(vim.g.roslyn_nvim_selected_solution)
        local files = vim
          .iter(projects)
          :map(function(it)
            return vim.fs.dirname(it)
          end)
          :totable()

        Snacks.picker.files({ dirs = files })
      end,
      desc = 'Search files in solution',
    },
  }
end
