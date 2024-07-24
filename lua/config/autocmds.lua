local function augroup(name)
  return vim.api.nvim_create_augroup('jarmex_neovim_' .. name, { clear = true })
end

local function write_commit_prefix()
  -- Run the Git command to get the current branch name
  local handle = io.popen('git branch --show-current')
  if not handle then
    return
  end
  local branch = handle:read('*a')
  handle:close()

  -- Trim whitespace from the branch name
  branch = string.gsub(branch, '^%s*(.-)%s*$', '%1')

  -- Check if the branch name contains 'UT-XXXX'
  local ut_number = string.match(branch, 'PLATFORM%-%d%d%d%d')
  if ut_number then
    -- Insert 'PLATFORM-XXXX: ' at the beginning of the buffer
    local insert_text = ut_number .. ': '
    vim.api.nvim_buf_set_lines(0, 0, 1, false, { insert_text })

    -- put the cursor in insert mode at the end of the line
  end
  vim.api.nvim_feedkeys('A', 'n', true)
end

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = { 'qf', 'help', 'man', 'lspinfo', 'spectre_panel' },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

local group = vim.api.nvim_create_augroup('__env', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '.env',
  group = group,
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.graphql,*.graphqls,*.gql',
  callback = function()
    vim.bo.filetype = 'graphql'
  end,
  once = false,
})

-- Define local variables
local autocmd = vim.api.nvim_create_autocmd
local user_cmd = vim.api.nvim_create_user_command

-- Check for spelling in text filetypes and enable wrapping, and set gj and gk keymaps
autocmd('FileType', {
  group = augroup('set_wrap'),
  pattern = {
    'gitcommit',
    'markdown',
    'text',
  },
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', opts)
  end,
})
-- local mapfile = " "
user_cmd('BiPolar', function(_)
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

-- Set up the autocommand for NeogitCommitMessage filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'gitcommit',
  callback = write_commit_prefix,
})
