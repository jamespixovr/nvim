return {
  --  overseer [task runner]
  --  https://github.com/stevearc/overseer.nvim
  {
    'stevearc/overseer.nvim',
    event = 'VeryLazy',
    keys = {
      { '<leader>o', '', desc = 'Overseer' },
      { '<leader>oR', '<cmd>OverseerRunCmd<cr>', desc = 'Run Command' },
      { '<leader>oa', '<cmd>OverseerTaskAction<cr>', desc = 'Task Action' },
      { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = 'Build' },
      { '<leader>oc', '<cmd>OverseerClose<cr>', desc = 'Close' },
      { '<leader>od', '<cmd>OverseerDeleteBundle<cr>', desc = 'Delete Bundle' },
      { '<leader>ol', '<cmd>OverseerLoadBundle<cr>', desc = 'Load Bundle' },
      { '<leader>oo', '<cmd>OverseerOpen<cr>', desc = 'Open' },
      { '<leader>oq', '<cmd>OverseerQuickAction<cr>', desc = 'Quick Action' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Run' },
      { '<leader>os', '<cmd>OverseerSaveBundle<cr>', desc = 'Save Bundle' },
      { '<leader>ot', '<cmd>OverseerToggle<cr>', desc = 'Toggle' },
      { '<leader>oh', '<cmd>OverseerClearCache<cr>', desc = 'Clear cache' },
    },
    opts = {
      templates = { 'make', 'user', 'vscode', 'task', 'shell' },
      dap = false,
      strategy = { 'jobstart', preserve_output = true, use_terminal = true },
      task_launcher = {
        bindings = {
          n = {
            ['<leader>c'] = 'Cancel',
          },
        },
      },
      task_list = {
        default_detail = 2,
        direction = 'bottom',
        min_height = 15,
        max_height = 15,
        min_width = 0.4,
        max_width = 0.4,
        separator = '',
        bindings = {
          ---@diagnostic disable-next-line: assign-type-mismatch
          ['<C-s>'] = false,
          ['<C-h>'] = false,
          ['<C-j>'] = false,
          ['<C-k>'] = false,
          ['<C-l>'] = false,
          ['<C-x>'] = 'OpenSplit',
          ['zo'] = 'IncreaseDetail',
          ['zc'] = 'DecreaseDetail',
          ['zr'] = 'IncreaseDetail',
          ['zm'] = 'DecreaseDetail',
          [']'] = false,
          ['['] = false,
          ['[t'] = 'PrevTask',
          [']t'] = 'NextTask',
          ['<C-r>'] = '<CMD>OverseerQuickAction restart<CR>',
          ['<C-d>'] = '<CMD>OverseerQuickAction dispose<CR>',
          ['<A-v>'] = 'TogglePreview',
          ['<A-j>'] = 'ScrollOutputDown',
          ['<A-k>'] = 'ScrollOutputUp',
          ['dd'] = 'Dispose',
          ['ss'] = 'Stop',
        },
        -- default_detail = 1,
      },
      form = {
        border = vim.g.borderStyle,
        win_opts = {
          winblend = 0,
          winhl = 'FloatBorder:NormalFloat',
        },
      },
      confirm = {
        win_opts = {
          winblend = 0,
        },
      },
      task_win = {
        win_opts = {
          winblend = 0,
        },
      },
      component_aliases = {
        default = {
          { 'display_duration', detail_level = 2 },
          'on_result_notify',
          'on_exit_set_status',
          { 'on_complete_notify', system = 'unfocused' },
          'on_complete_dispose',
        },
        default_neotest = {
          'unique',
          'on_output_summarize',
          'on_exit_set_status',
          'on_complete_dispose',
        },
      },
    },
    config = function(_, opts)
      local overseer = require('overseer')
      overseer.setup(opts)

      vim.api.nvim_create_user_command('OverseerDebugParser', 'lua require("overseer").debug_parser()', {})
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'OverseerList',
        group = vim.api.nvim_create_augroup('OverseerConfig', {}),
        callback = function(e)
          vim.opt_local.winfixbuf = true
          vim.defer_fn(function()
            vim.cmd('stopinsert')
          end, 1)

          vim.keymap.set('n', 'q', function()
            pcall(vim.api.nvim_win_close, 0, true)
            vim.cmd('wincmd p')
          end, { buffer = e.buf })
        end,
      })

      vim.api.nvim_create_user_command('Grep', function(params)
        local args = vim.fn.expandcmd(params.args)
        -- Insert args at the '$*' in the grepprg
        local cmd, num_subs = vim.o.grepprg:gsub('%$%*', args)
        if num_subs == 0 then
          cmd = cmd .. ' ' .. args
        end
        local cwd
        local has_oil, oil = pcall(require, 'oil')
        if has_oil then
          cwd = oil.get_current_dir()
        end
        local task = overseer.new_task({
          cmd = cmd,
          cwd = cwd,
          name = 'grep ' .. args,
          components = {
            {
              'on_output_quickfix',
              errorformat = vim.o.grepformat,
              open = not params.bang,
              open_height = 8,
              items_only = true,
            },
            { 'on_complete_dispose', timeout = 30 },
            'default',
          },
        })
        task:start()
      end, { nargs = '*', bang = true, bar = true, complete = 'file' })

      vim.api.nvim_create_user_command('Make', function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub('%$%*', params.args)
        if num_subs == 0 then
          cmd = cmd .. ' ' .. params.args
        end
        local task = require('overseer').new_task({
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { 'on_output_quickfix', open = not params.bang, open_height = 8 },
            'unique',
            'default',
          },
        })
        task:start()
      end, {
        desc = 'Run your makeprg as an Overseer task',
        nargs = '*',
        bang = true,
      })
    end,
  },
}
