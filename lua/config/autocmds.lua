local function augroup(name)
  return vim.api.nvim_create_augroup('jarmex_neovim_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = augroup('general_settings'),
  pattern = '*',
  desc = 'Highlight text on yank',
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
    vim.highlight.on_yank({ higroup = 'Search', timeout = 100 })
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('filetype_settings'),
  pattern = { 'lua' },
  desc = 'fix gf functionality inside .lua files',
  callback = function()
    ---@diagnostic disable: assign-type-mismatch
    -- credit: https://github.com/sam4llis/nvim-lua-gf
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend('.lua')
    vim.opt_local.suffixesadd:prepend('init.lua')

    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. '/lua')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('buffer_mappings'),
  pattern = {
    'spectre_panel',
    'qf',
    'help',
    'man',
    'floaterm',
    'lspinfo',
    'lir',
    'lsp-installer',
    'null-ls-info',
    'tsplayground',
    'DressingSelect',
    'Jaq',
    'neotest-output',
    'neotest-summary',
    'OverseerList',
    'dropbar_menu',
  },
  callback = function()
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = true })
    vim.opt_local.buflisted = false
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
    'plaintex',
  },
  desc = 'setlocal wrap and spell',
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

-- Set up the autocommand for NeotestOutput filetype
-- Scroll to the bottom of the output panel
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'neotest-output-panel',
  group = vim.api.nvim_create_augroup('neotest-scroll', { clear = true }),
  callback = function()
    vim.cmd('norm G')
  end,
})

-- Set up the autocommand for TS filetype
-- Add missing imports and remove unused imports
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('ts_fix_imports', { clear = true }),
  desc = 'Add missing imports and remove unused imports for TS',
  pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
  callback = function(args)
    vim.cmd('TSToolsAddMissingImports sync')
    vim.cmd('TSToolsRemoveUnusedImports sync')
    if package.loaded['conform'] then
      require('conform').format({ bufnr = args.buf })
    end
  end,
})
