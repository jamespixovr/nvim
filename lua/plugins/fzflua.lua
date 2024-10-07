local prompt = ' '

local function title(str, icon, icon_hl)
  return { { ' ' }, { (icon or ''), icon_hl or 'DevIconDefault' }, { ' ' }, { str, 'Bold' }, { ' ' } }
end

local function ivy(opts, ...)
  opts = opts or {}
  opts['winopts'] = opts.winopts or {}

  return vim.tbl_deep_extend('force', {
    prompt = ' ',
    fzf_opts = { ['--layout'] = 'reverse' },
    winopts = {
      title_pos = opts['winopts'].title and 'center' or nil,
      height = 0.35,
      width = 1.00,
      row = 0.98,
      col = 1,
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
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

return {
  {
    'ibhagwan/fzf-lua',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>fn', ':FzfLua<cr>', desc = 'Fzf Lua' },
    },
    config = function()
      -- calling `setup` is optional for customization
      local actions = require('fzf-lua.actions')

      local fzf_lua = require('fzf-lua')
      local function file_picker(opts_or_cwd)
        if type(opts_or_cwd) == 'table' then
          fzf_lua.files(ivy(opts_or_cwd))
        else
          fzf_lua.files(ivy({ cwd = opts_or_cwd }))
        end
      end

      fzf_lua.setup({
        defaults = {
          file_icons = false,
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
          fzf_opts = { ['--delimiter'] = "' '", ['--with-nth'] = '-1..' },
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
          actions = { ['ctrl-g'] = fzf_lua.actions.grep_lgrep },
          rg_glob_fn = function(query, opts)
            -- this enables all `rg` arguments to be passed in after the `--` glob separator
            local search_query, glob_str = query:match('(.*)' .. opts.glob_separator .. '(.*)')
            local glob_args = glob_str:gsub('^%s+', ''):gsub('-', '%-') .. ' '

            return search_query, glob_args
          end,
        },
        lsp = {
          cwd_only = true,
          code_actions = cursor_dropdown({
            winopts = { title = title('Code Actions', '', '@type') },
          }),
        },
        jumps = dropdown({
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
