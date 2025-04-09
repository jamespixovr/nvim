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

vim.api.nvim_create_user_command('OverseerRestartLast', function()
  local overseer = require('overseer')
  local tasks = overseer.list_tasks({ recent_first = true })
  if vim.tbl_isempty(tasks) then
    vim.notify('No tasks found', vim.log.levels.WARN, { title = 'Overseer' })
  else
    overseer.run_action(tasks[1], 'restart')
  end
end, {})

vim.api.nvim_create_user_command('OverseerFromTerminal', function()
  local cmd = ''

  -- Check if there is a visual selection
  local mode = vim.api.nvim_get_mode().mode
  if mode == 'v' or mode == 'V' or mode == '' then
    cmd = table.concat(vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = mode }), '\n')
  end

  -- If no selection, fall back to last line of the terminal buffer
  if cmd == '' then
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
    cmd = vim.api.nvim_buf_get_lines(0, cursor_row - 1, cursor_row, false)[1]
    cmd = cmd:gsub('^%S+%s*', '') -- remove the first word (terminal icon such as ~)
    cmd = cmd:gsub('%s*%S+%s*$', '') -- remove the last word
  end

  vim.notify('Starting ' .. cmd, vim.log.levels.INFO, { title = 'Overseer' })
  require('overseer').new_task({ cmd = cmd }):start()
end, {})
