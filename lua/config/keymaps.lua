local function keymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  if opts.unique == nil then
    opts.unique = true
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- Better window movement
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', noremap = true })

vim.keymap.set('n', 'Y', 'y$', { remap = true })
-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', 'g,', 'g,zvzz')
keymap('n', 'g;', 'g;zvzz')
keymap('n', 'J', 'mzJ`z')
keymap('n', '<C-d>', '<C-d>zz')
keymap('n', '<C-u>', '<C-u>zz')
keymap('n', '=ap', "ma=ap'a")
keymap('n', '<leader>zr', '<cmd>LspRestart<cr>')

-- Better indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

vim.keymap.set('n', '<Leader>r', ':%s/<c-r><c-w>//g<left><left>', { desc = 'Rename word under cursor' })
-- Paste over currently selected text without yanking it
-- keymap('v', 'p', '"_dP')
-- keymap('x', '<leader>p', [["_dP]])
keymap({ 'n', 'v' }, '<leader>y', [["+y]])
keymap('n', '<leader>Y', [["+Y]])

-- COMMAND & INSERT MODE
keymap({ 'i', 'c' }, '<C-a>', '<Home>')
-- keymap({ 'i', 'c' }, '<C-e>', '<End>')

-- navigation
keymap('i', '<M-Up>', '<C-\\><C-N><C-w>k')
keymap('i', '<M-Down>', '<C-\\><C-N><C-w>j')
keymap('i', '<M-Left>', '<C-\\><C-N><C-w>h')
keymap('i', '<M-Right>', '<C-\\><C-N><C-w>l')

-- Terminal Mappings
keymap('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
keymap('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
keymap('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
keymap('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
keymap('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
keymap('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
keymap('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })

-- Clear search with <esc>
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>', { desc = 'Clear hlsearch', nowait = true })
vim.keymap.set({ 'n', 'i' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- buffers
vim.keymap.set('n', '<leader>`', '<C-^>', { noremap = true, desc = 'Alternate buffers' })
keymap('n', '<leader>bo', '<cmd>b#<cr>', { desc = 'Switch to Other Buffer' })

-- lazy
keymap('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- windows
keymap('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
keymap('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
keymap('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
-- keymap('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
-- keymap('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

keymap('x', 'K', ":m '<-2<CR>gv-gv")
keymap('x', 'J', ":m '>+1<CR>gv-gv")

-- OPTION TOGGLING
-- toggle inlay hints
-- keymap('n', '<leader>uh', function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
-- end)

-- Resize windows using <ctrl> arrow keys
keymap('n', '<M-Up>', ':resize +2<CR>', { desc = 'Increase window height', silent = true })
keymap('n', '<M-Down>', ':resize -2<CR>', { desc = 'Decrease window height', silent = true })
keymap('n', '<M-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width', silent = true })
keymap('n', '<M-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width', silent = true })

-- keymap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Tabs
keymap('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
keymap('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
keymap('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
keymap('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
keymap('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
keymap('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
keymap('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab', silent = true })
keymap('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab', silent = true })

-- quickfix list
keymap('n', '<leader>xq', function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })

-- keymap('n', '[q', vim.cmd.cprev, { desc = ' Previous Quickfix' })
-- keymap('n', ']q', vim.cmd.cnext, { desc = ' Next Quickfix' })
keymap('n', '<C-q>', ':call QuickFixToggle()<CR>')
keymap('n', 'dQ', function()
  vim.cmd.cexpr('[]')
end, { desc = ' Delete Quickfix List' })

-- adapted from
-- https://github.com/rachartier/dotfiles/blob/main/.config/nvim/lua/remap.lua
local map = vim.keymap.set

map('n', 'dd', function()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return '"_dd'
  else
    return 'dd'
  end
end, { expr = true, desc = 'Smart dd' })
