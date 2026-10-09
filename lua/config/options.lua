--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
local default_options = {
  backup = false, -- creates a backup file
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  cmdheight = 0, -- more space in the neovim command line for displaying messages
  -- colorcolumn = '99999', -- fixes indentline for now
  completeopt = 'menu,menuone,noselect,noinsert,nearest',
  conceallevel = 2, -- Hide * markup for bold and italic
  fileencoding = 'utf-8', -- the encoding written to a file
  foldenable = true, -- Enable folding
  foldmethod = 'indent', -- folding, set to "expr" for treesitter based folding
  foldexpr = '', -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  foldcolumn = '1',
  foldlevel = 99,
  foldlevelstart = 99,
  hidden = true, -- required to keep multiple buffers and open multiple buffers
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = 'a', -- allow the mouse to be used in neovim
  pumheight = 15, -- pop up menu height
  pumwidth = 15, -- min width
  showmode = false, -- we don't need to see things like -- INSERT -- anymore (dont show mode since we have a statusline)
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeout = true, -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
  timeoutlen = 300, -- Time in milliseconds to wait for a mapped sequence to complete.
  ttimeoutlen = 10, -- Time in milliseconds to wait for a key code sequence to complete
  updatetime = 280, -- If in this milliseconds nothing is typed, the swap file will be written to disk.
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  ruler = false, -- Disable the default ruler
  laststatus = 3,
  number = true, -- set numbered lines
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  wrap = false, -- display lines as one long line
  linebreak = true,
  spell = false,
  confirm = true, -- Confirm to save changes before exiting modified buffer
  encoding = 'UTF-8', -- Set the encoding type
  incsearch = true, -- Shows the match while typing
  inccommand = 'split', -- information about all identifiers to be renamed
  -- cmdwinheight = 25, --change the height of the preview window
  shiftround = true, -- Round indent
  undofile = true,
  undolevels = 1000,
  -- Indenting
  expandtab = true, -- convert tabs to spaces
  smartindent = true, -- make indenting smarter again
  tabstop = 2, -- insert 2 spaces for a tab
  softtabstop = 2,
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' },
  -- virtualedit = 'block', -- Allow cursor to move where there is no text in visual block mode
  -- wildmode = 'longest:full,full', -- Command-line completion mode
  -- grepprg = 'rg --vimgrep',
  grepformat = '%f:%l:%c:%m',
  fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
    stl = ' ',
    stlnc = ' ',
    wbr = ' ',
    horiz = '─',
    horizup = '┴',
    horizdown = '┬',
    vert = '│',
    vertleft = '┤',
    vertright = '├',
    verthoriz = '┼',
  },
  -- winminwidth = 5, -- Minimum window width
  spelllang = 'en_us',
  spellsuggest = 'best,20', -- Limits to 20 suggestions
  splitkeep = 'screen',
  jumpoptions = 'view',
  autoread = true, -- reload files when changed outside of vim
}

for k, v in pairs(default_options) do
  vim.opt[k] = v
end

---APPEARANCE-------------------------------------------------------------------
vim.opt.cursorline = true -- highlight the current line
vim.opt.signcolumn = 'yes:1'
vim.opt.colorcolumn = '+1' -- = one more than textwidth

vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 5

vim.opt.winborder = vim.g.border.style

vim.opt.pumheight = 12 -- max height of native completion menu
----------------

vim.opt.jumpoptions:append('stack') -- https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?context=3
vim.opt.startofline = true -- motions like "G" also move to the first char
vim.opt.mousescroll = 'ver:1,hor:3' -- more fine-grained scrolling with mouse

vim.opt.wildignore:append({
  '*.DS_Store',
  '*.aiff',
  '*.bz2',
  '*.cache',
  '*.class',
  '*.dll',
  '*.dll',
  '*.gif',
  '*.gz',
  '*.jpeg',
  '*.jpg',
  '*.mdb',
  '*.meta',
  '*.o',
  '*.obj',
  '*.pdb',
  '*.png',
  '*.pyc',
  '*.so',
  '*.svg',
  '*.swo',
  '*.swp',
  '*.wav',
  '*.zip',
  '*/.git/*',
  '*/.venv/*',
  '*/build/*',
  '*/dist/*',
  '*/node_modules/*',
  '*/target/*',
  '*/venv/*',
})

-- vim.opt.grepprg = vim.fn.executable('rg') == 1 and 'rg --vimgrep --smart-case --follow' or 'grep -n $* /dev/null'

if vim.fn.executable('rg') == 1 then
  vim.o.grepprg = 'rg --vimgrep --no-heading --smart-case'
  vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
elseif vim.fn.executable('ag') == 1 then
  vim.o.grepprg = 'ag --vimgrep'
  vim.o.grepformat = '%f:%l:%c:%m'
elseif vim.fn.executable('ack') == 1 then
  vim.o.grepprg = 'ack --nogroup --nocolor'
elseif vim.fn.finddir('.git', '.;') ~= '' then
  vim.o.grepprg = 'git --no-pager grep --no-color -n'
  vim.o.grepformat = '%f:%l:%m,%m %f match%ts,%f'
else
  vim.o.grepprg = 'grep -nIR $* /dev/null'
end

vim.opt.listchars = {
  tab = '» ',
  trail = '·',
  extends = '',
  precedes = '',
}
--
-- set titlestring to $cwd if TERM_PROGRAM=ghostty
if vim.fn.getenv('TERM_PROGRAM') == 'ghostty' then
  vim.opt.title = true
  vim.opt.titlestring = "%{fnamemodify(getcwd(), ':t')}"
end

-- project specific settings (see lazyrc.lua for .lazy.lua support)
-- vim.opt.exrc = true -- allow local .nvim.lua .vimrc .exrc files
-- vim.opt.secure = true -- disable shell and write commands in local .nvim.lua .vimrc .exrc files
