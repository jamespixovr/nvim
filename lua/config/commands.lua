-- json
vim.api.nvim_create_user_command('JsonDemangle', "%!jq '.'", { force = true })
-- vim.api.nvim_create_user_command('Uuid', 'read !uuidgen', { force = true })

vim.api.nvim_create_user_command('Uuid', function()
  local uuid = vim.fn.system('uuidgen'):gsub('\n', ''):lower()
  local line = vim.fn.getline('.')
  vim.schedule(function()
    vim.fn.setline('.', vim.fn.strpart(line, 0, vim.fn.col('.')) .. uuid .. vim.fn.strpart(line, vim.fn.col('.')))
  end)
end, { force = true })

vim.api.nvim_create_user_command('BiPolar', function(_)
  local moods_table = {
    ['true'] = 'false',
    ['false'] = 'true',
    ['on'] = 'off',
    ['off'] = 'on',
    ['Up'] = 'Down',
    ['Down'] = 'Up',
    ['up'] = 'down',
    ['down'] = 'up',
    ['enable'] = 'disable',
    ['disable'] = 'enable',
    ['no'] = 'yes',
    ['yes'] = 'no',
  }
  local cursor_word = vim.api.nvim_eval("expand('<cword>')")
  if moods_table[cursor_word] then
    vim.cmd('normal ciw' .. moods_table[cursor_word] .. '')
  end
end, {
  desc = 'Switch Moody Words',
  force = true,
})

vim.api.nvim_create_user_command('CucumberTest', function()
  require('overseer').run_template({ name = 'cucumber test' })
end, {})

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = 'Disable autoformat-on-save',
  bang = true,
})
vim.api.nvim_create_user_command('FormatEnable', function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = 'Re-enable autoformat-on-save',
})
