--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
vim.opt.backup = false -- creates a backup file
vim.opt.clipboard = 'unnamedplus' -- allows neovim to access the system clipboard
vim.opt.cmdheight = 0 -- more space in the neovim command line for displaying messages
-- vim.opt.colorcolumn = '99999', -- fixes indentline for now
vim.opt.completeopt = 'menu,menuone,noselect,noinsert,nearest'
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic
vim.opt.fileencoding = 'utf-8' -- the encoding written to a file
vim.opt.foldenable = true -- Enable folding
vim.opt.foldmethod = 'indent' -- folding, set to "expr" for treesitter based folding
vim.opt.foldexpr = '' -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
vim.opt.foldcolumn = '1'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.hidden = true -- required to keep multiple buffers and open multiple buffers
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.mouse = 'a' -- allow the mouse to be used in neovim
vim.opt.pumheight = 15 -- pop up menu height
vim.opt.pumwidth = 15 -- min width
vim.opt.showmode = false -- we don't need to see things like -- INSERT -- anymore (dont show mode since we have a statusline)
vim.opt.showtabline = 2 -- always show tabs
vim.opt.smartcase = true -- smart case
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false -- creates a swapfile
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.timeout = true -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
vim.opt.timeoutlen = 300 -- Time in milliseconds to wait for a mapped sequence to complete.
vim.opt.ttimeoutlen = 10 -- Time in milliseconds to wait for a key code sequence to complete
vim.opt.updatetime = 280 -- If in this milliseconds nothing is typed, the swap file will be written to disk.
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.ruler = false -- Disable the default ruler
vim.opt.laststatus = 3
vim.opt.number = true -- set numbered lines
vim.opt.relativenumber = true -- set relative numbered lines
vim.opt.numberwidth = 2 -- set number column width to 2 {default 4}
vim.opt.wrap = false -- display lines as one long line
vim.opt.linebreak = true
vim.opt.spell = false
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.encoding = 'UTF-8' -- Set the encoding type
vim.opt.incsearch = true -- Shows the match while typing
vim.opt.inccommand = 'split' -- information about all identifiers to be renamed
-- vim.opt.cmdwinheight = 25 --change the height of the preview window
vim.opt.shiftround = true -- Round indent
vim.opt.undofile = true
vim.opt.undolevels = 1000
-- Indenting
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.tabstop = 2 -- insert 2 spaces for a tab
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' }
-- vim.opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
-- vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
-- vim.opt.grepprg = 'rg --vimgrep'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.fillchars = {
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
}
-- winminwidth = 5, -- Minimum window width
vim.opt.spelllang = 'en_us'
vim.opt.spellsuggest = 'best,20' -- Limits to 20 suggestions
vim.opt.splitkeep = 'screen'
vim.opt.jumpoptions = 'view'
vim.opt.autoread = true -- reload files when changed outside of vim

---APPEARANCE-------------------------------------------------------------------
vim.opt.cursorline = true -- highlight the current line
vim.opt.signcolumn = 'yes:1'
vim.opt.colorcolumn = '+1' -- = one more than textwidth

vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 5

vim.opt.winborder = vim.g.border.style

vim.opt.pumheight = 12 -- max height of native completion menu
----------------

vim.opt.jumpoptions = 'stack,view'
vim.opt.startofline = true -- motions like "G" also move to the first char
vim.opt.mousescroll = 'ver:1,hor:3' -- more fine-grained scrolling with mouse

-- vim.opt.wildignore:append({
--   '*.DS_Store',
--   '*.aiff',
--   '*.bz2',
--   '*.cache',
--   '*.class',
--   '*.dll',
--   '*.dll',
--   '*.gif',
--   '*.gz',
--   '*.jpeg',
--   '*.jpg',
--   '*.mdb',
--   '*.meta',
--   '*.o',
--   '*.obj',
--   '*.pdb',
--   '*.png',
--   '*.pyc',
--   '*.so',
--   '*.svg',
--   '*.swo',
--   '*.swp',
--   '*.wav',
--   '*.zip',
--   '*/.git/*',
--   '*/.venv/*',
--   '*/build/*',
--   '*/dist/*',
--   '*/node_modules/*',
--   '*/target/*',
--   '*/venv/*',
-- })

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
