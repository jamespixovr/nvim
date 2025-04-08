local function open_first_failed_task()
  local overseer = require('overseer')
  local constants = require('overseer.constants')
  local action_util = require('overseer.action_util')
  local failed_tasks = overseer.list_tasks({ status = constants.STATUS.FAILURE })
  if #failed_tasks > 0 then
    local task = failed_tasks[1] ---@type overseer.Task
    action_util.run_task_action(task, 'open hsplit')
  else
    vim.notify('No failed tasks found', vim.log.levels.WARN, { title = 'Overseer' })
  end
end
return {
  --  overseer [task runner]
  --  https://github.com/stevearc/overseer.nvim
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerRun', 'OverseerInfo', 'OverseerToggle', 'OverseerFromTerminal' },
    keys = {
      { '<leader>o', '', desc = 'Overseer' },
      { '<leader>oR', '<cmd>OverseerRunCmd<cr>', desc = 'Run Command' },
      { '<leader>ol', '<cmd>OverseerTaskAction<cr>', desc = 'Task Action' },
      { '<leader>ob', '<cmd>OverseerBuild<cr>', desc = 'Build' },
      { '<leader>oc', '<cmd>OverseerClose<cr>', desc = 'Close' },
      { '<leader>od', '<cmd>OverseerDeleteBundle<cr>', desc = 'Delete Bundle' },
      { '<leader>ob', '<cmd>OverseerLoadBundle<cr>', desc = 'Load Bundle' },
      { '<leader>oi', '<cmd>OverseerInfo<cr>', desc = 'Overseer Info' },
      { '<leader>oo', '<cmd>OverseerOpen<cr>', desc = 'Open' },
      { '<leader>oq', '<cmd>OverseerQuickAction<cr>', desc = 'Quick Action' },
      { '<leader>or', '<cmd>OverseerRun<cr>', desc = 'Run' },
      { '<leader>os', '<cmd>OverseerSaveBundle<cr>', desc = 'Save Bundle' },
      { '<leader>ot', '<cmd>OverseerToggle<cr>', desc = 'Toggle' },
      { '<leader>oh', '<cmd>OverseerClearCache<cr>', desc = 'Clear cache' },
      { '<leader>ox', '<cmd>OverseerFromTerminal<cr>', mode = { 'n', 'v' }, desc = 'Overseer From Terminal' },
      { '<leader>oa', '<cmd>OverseerRestartLast<cr>', desc = 'Overseer Restart Last' },
      { '<leader>op', open_first_failed_task, desc = 'Overseer Open Failed Task' },
    },
    opts = {
      templates = { 'make', 'user', 'vscode', 'task', 'shell' },
      dap = false,
      strategy = { 'jobstart', preserve_output = true, use_terminal = true, use_shell = true },
      -- strategy = {
      --   'toggleterm',
      --   auto_scroll = false,
      --   close_on_exit = false,
      --   hidden = false,
      --   open_on_start = false,
      --   quit_on_exit = 'never',
      --   use_shell = true,
      -- },
      task_launcher = {
        bindings = {
          n = {
            ['<leader>c'] = 'Cancel',
          },
        },
      },
      task_list = {
        default_detail = 2,
        -- direction = 'bottom',
        direction = 'right',
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
          'on_output_summarize',
          'on_exit_set_status',
          { 'on_complete_notify', system = 'unfocused' },
          { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
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

      require('plugins.overseer.commands')
    end,
  },
}
