-- REF: https://github.com/megalithic/dotfiles/blob/main/config/nvim/lua/plugins/extended/fzf.lua

---@param require_path string
---@return table<string, fun(...): any>
local function reqcall(require_path)
  return setmetatable({}, {
    __index = function(_, k)
      return function(...)
        return require(require_path)[k](...)
      end
    end,
  })
end

local fzf_lua = reqcall('fzf-lua')

local prompt = '~> '

local function title(str, icon, icon_hl)
  return { { ' ' }, { (icon or ''), icon_hl or 'DevIconDefault' }, { ' ' }, { str, 'Bold' }, { ' ' } }
end

local function ivy(opts, ...)
  opts = opts or {}
  opts['winopts'] = opts.winopts or {}

  return vim.tbl_deep_extend('force', {
    prompt = prompt,
    fzf_opts = { ['--layout'] = 'reverse' },
    winopts = {
      title_pos = opts['winopts'].title and 'center' or nil,
      height = 0.35,
      width = 1.00,
      row = 0.98,
      col = 1,
      -- border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
      preview = {
        layout = 'flex',
        hidden = 'nohidden',
        flip_columns = 130,
        scrollbar = 'float',
        scrolloff = '-1',
        scrollchars = { '█', '░' },
      },
    },
  }, opts, ...)
end

local function dropdown(opts, ...)
  -- dd(I(opts))
  opts = opts or {}
  opts['winopts'] = opts.winopts or {}

  return vim.tbl_deep_extend('force', {
    prompt = ' ',
    fzf_opts = { ['--layout'] = 'reverse' },
    winopts = {
      title_pos = opts['winopts'].title and 'center' or nil,
      height = 0.70,
      width = 0.45,
      row = 0.1,
      col = 0.5,
      preview = { hidden = 'hidden', layout = 'vertical', vertical = 'up:50%' },
    },
  }, opts, ...)
end

local function cursor_dropdown(opts)
  return dropdown({
    winopts = {
      row = 1,
      relative = 'cursor',
      height = 0.33,
      width = 0.25,
    },
  }, opts)
end

local function file_picker(opts_or_cwd)
  if type(opts_or_cwd) == 'table' then
    fzf_lua.files(ivy(opts_or_cwd))
  else
    fzf_lua.files(ivy({ cwd = opts_or_cwd }))
  end
end

local function git_files_cwd_aware(opts)
  opts = opts or {}
  local fzf = require('fzf-lua')
  -- git_root() will warn us if we're not inside a git repo
  -- so we don't have to add another warning here, if
  -- you want to avoid the error message change it to:
  -- local git_root = fzf_lua.path.git_root(opts, true)
  local git_root = fzf.path.git_root(opts)
  if not git_root then
    return fzf.files(ivy(opts))
  end
  local relative = fzf.path.relative(vim.loop.cwd(), git_root)
  opts.fzf_opts = { ['--query'] = git_root ~= relative and relative or nil }
  return fzf.git_files(ivy(opts))
end

local keys = {
  { '<leader>fn', ':FzfLua<cr>', desc = 'Fzf Lua' },
  { '<leader>sf', ':FzfLua grep_cword<cr>', desc = 'Search word under cursor' },
  { '<leader>ff', file_picker, desc = 'Find Files' },
  { '<leader>fo', fzf_lua.oldfiles, desc = 'oldfiles' },
  { '<leader>fm', fzf_lua.marks, desc = 'marks' },
  { '<leader>A', fzf_lua.grep_cword, desc = 'grep (under cursor)' },
  { '<leader>A', fzf_lua.grep_visual, desc = 'grep (visual selection)', mode = 'v' },
  { '<leader>fa', fzf_lua.live_grep_glob, desc = 'live grep' },
  { '<leader>fr', fzf_lua.resume, desc = 'resume picker' },
}
if vim.g.picker == 'fzf_lua' then
  keys = {
    { '<c-p>', git_files_cwd_aware, desc = 'find files' },
    { '<leader>fa', '<Cmd>FzfLua<CR>', desc = 'builtins' },
    { '<leader>ff', file_picker, desc = 'find files' },
    { '<leader>fo', fzf_lua.oldfiles, desc = 'oldfiles' },
    { '<leader>fr', fzf_lua.resume, desc = 'resume picker' },
    { '<leader>fh', fzf_lua.highlights, desc = 'highlights' },
    { '<leader>fm', fzf_lua.marks, desc = 'marks' },
    { '<leader>fk', fzf_lua.keymaps, desc = 'keymaps' },
    { '<leader>flw', fzf_lua.diagnostics_workspace, desc = 'workspace diagnostics' },
    { '<leader>fls', fzf_lua.lsp_document_symbols, desc = 'document symbols' },
    { '<leader>flS', fzf_lua.lsp_live_workspace_symbols, desc = 'workspace symbols' },
    { '<leader>f?', fzf_lua.help_tags, desc = 'help' },
    { '<leader>fgb', fzf_lua.git_branches, desc = 'branches' },
    { '<leader>fgc', fzf_lua.git_commits, desc = 'commits' },
    { '<leader>fgB', fzf_lua.git_bcommits, desc = 'buffer commits' },
    { '<leader>fb', fzf_lua.buffers, desc = 'buffers' },
    { '<leader>a', fzf_lua.live_grep_glob, desc = 'live grep' },
    { '<leader>A', fzf_lua.grep_cword, desc = 'grep (under cursor)' },
    { '<leader>A', fzf_lua.grep_visual, desc = 'grep (visual selection)', mode = 'v' },
    { '<leader>fva', fzf_lua.autocmds, desc = 'autocommands' },
    { '<leader>fp', fzf_lua.registers, desc = 'registers' },
    {
      '<leader>fd',
      function()
        file_picker(vim.env.DOTFILES)
      end,
      desc = 'dotfiles',
    },
    {
      '<leader>fc',
      function()
        file_picker(vim.g.vim_path)
      end,
      desc = 'nvim config',
    },
    {
      '<leader>fn',
      function()
        file_picker(vim.g.neorg_path)
      end,
      desc = 'neorg files',
    },
    -- { "<leader>fN", function() file_picker(env.SYNC_DIR .. "/notes/neorg") end, desc = "norg files" },
  }
end

return {
  {
    'ibhagwan/fzf-lua',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- keys = {
    --   { '<leader>fn', ':FzfLua<cr>', desc = 'Fzf Lua' },
    -- },
    keys = keys,
    config = function()
      -- calling `setup` is optional for customization
      local actions = require('fzf-lua.actions')
      local fzf = require('fzf-lua')

      fzf.setup({
        defaults = {
          file_icons = false,
          git_icons = false,
          color_icons = false,
        },
        winopts = {
          title_pos = nil,
          width = 0.90,
          preview = {
            -- layout = 'vertical',
            -- vertical = 'up:70%', -- up|down:size
            layout = 'flex',
            flip_columns = 130,
            scrollbar = 'float',
            scrolloff = '-1',
            scrollchars = { '█', '░' },
          },
        },
        actions = {
          files = {
            ['default'] = actions.file_edit_or_qf,
            ['ctrl-q'] = actions.file_sel_to_qf,
            ['ctrl-v'] = actions.file_vsplit,
          },
        },
        fzf_opts = {
          ['--layout'] = false,
        },
        git = {
          files = {
            prompt = '> ',
            cmd = 'git ls-files --exclude-standard --others --cached',
          },
        },
        previewers = {
          builtin = {
            toggle_behavior = 'extend',
            syntax_limit_l = 0, -- syntax limit (lines), 0=nolimit
            syntax_limit_b = 1024 * 1024, -- syntax limit (bytes), 0=nolimit
            limit_b = 1024 * 1024 * 10, -- preview limit (bytes), 0=nolimit
            extensions = {
              ['png'] = { 'viu', '-b' },
            },
          },
        },
        hhighlights = {
          prompt = prompt,
          winopts = { title = title('Highlights', '󰏘') },
        },
        helptags = {
          prompt = prompt,
          winopts = { title = title('Help', '󰋖') },
        },
        oldfiles = dropdown({
          cwd_only = true,
          stat_file = true, -- verify files exist on disk
          include_current_session = false, -- include bufs from current session
          winopts = { title = title('History', '') },
        }),
        files = {
          multiprocess = true,
          prompt = prompt,
          winopts = { title = title('Files', '') },
          -- previewer = "builtin",
          -- action = { ["ctrl-r"] = fzf.actions.arg_add },
        },
        buffers = dropdown({
          fzf_opts = { ['--delimiter'] = ' ', ['--with-nth'] = '-1..' },
          winopts = { title = title('Buffers', '󰈙') },
        }),
        keymaps = dropdown({
          winopts = { title = title('Keymaps', '') },
        }),
        registers = cursor_dropdown({
          winopts = { title = title('Registers', ''), width = 0.6 },
        }),
        grep = {
          multiprocess = true,
          prompt = ' ',
          winopts = { title = title('Grep', '󰈭') },
          rg_opts = "--hidden --column --line-number --no-ignore-vcs --no-heading --color=always --smart-case -g '!.git'",
          rg_glob = true, -- enable glob parsing by default to all
          glob_flag = '--iglob', -- for case sensitive globs use '--glob'
          glob_separator = '%s%-%-', -- query separator pattern (lua): ' --'
          actions = { ['ctrl-g'] = fzf.actions.grep_lgrep },
          rg_glob_fn = function(query, opts)
            -- this enables all `rg` arguments to be passed in after the `--` glob separator
            local search_query, glob_str = query:match('(.*)' .. opts.glob_separator .. '(.*)')
            local glob_args = glob_str:gsub('^%s+', ''):gsub('-', '%-') .. ' '

            return search_query, glob_args
          end,
        },
        lsp = {
          -- cwd_only = true,
          code_actions = cursor_dropdown({
            winopts = { title = title('Code Actions', '', '@type') },
          }),
        },
        jumps = ivy({
          winopts = { title = title('Jumps', ''), preview = { hidden = 'nohidden' } },
        }),
        changes = dropdown({
          prompt = '',
          winopts = { title = title('Changes', '⟳'), preview = { hidden = 'nohidden' } },
        }),
        diagnostics = dropdown({
          winopts = { title = title('Diagnostics', '', 'DiagnosticError') },
        }),
      })
      fzf_lua.register_ui_select(dropdown({
        winopts = { title = title('Select one of:'), height = 0.33, row = 0.5 },
      }))
    end,
  },
}
