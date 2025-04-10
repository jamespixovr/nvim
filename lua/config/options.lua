--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
local default_options = {
  autowrite = true, -- Enable auto write
  backup = false, -- creates a backup file
  clipboard = 'unnamedplus', -- allows neovim to access the system clipboard
  -- cmdheight = 0, -- more space in the neovim command line for displaying messages
  colorcolumn = '99999', -- fixes indentline for now
  completeopt = 'menu,menuone,noselect',
  conceallevel = 2, -- Hide * markup for bold and italic
  fileencoding = 'utf-8', -- the encoding written to a file
  foldenable = true, -- Enable folding
  foldmethod = 'expr', -- folding, set to "expr" for treesitter based folding
  foldexpr = '', -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
  foldcolumn = '1',
  hidden = true, -- required to keep multiple buffers and open multiple buffers
  hlsearch = true, -- highlight all matches on previous search pattern
  ignorecase = true, -- ignore case in search patterns
  mouse = 'a', -- allow the mouse to be used in neovim
  pumheight = 12, -- pop up menu height
  pumwidth = 15, -- min width
  showmode = false, -- we don't need to see things like -- INSERT -- anymore (dont show mode since we have a statusline)
  showtabline = 2, -- always show tabs
  smartcase = true, -- smart case
  splitbelow = true, -- force all horizontal splits to go below current window
  splitright = true, -- force all vertical splits to go to the right of current window
  swapfile = false, -- creates a swapfile
  termguicolors = true, -- set term gui colors (most terminals support this)
  timeout = true, -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
  timeoutlen = 400, -- Time in milliseconds to wait for a mapped sequence to complete.
  ttimeoutlen = 10, -- Time in milliseconds to wait for a key code sequence to complete
  updatetime = 280, -- If in this milliseconds nothing is typed, the swap file will be written to disk.
  wildignore = { '*/.git/*', '*/node_modules/*' }, -- Ignore these files/folders
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  cursorline = true, -- highlight the current line
  number = true, -- set numbered lines
  ruler = false, -- Disable the default ruler
  laststatus = 3,
  relativenumber = true, -- set relative numbered lines
  numberwidth = 2, -- set number column width to 2 {default 4}
  signcolumn = 'yes', -- always show the sign column, otherwise it would shift the text each time
  wrap = false, -- display lines as one long line
  linebreak = true,
  spell = false,
  confirm = true, -- Confirm to save changes before exiting modified buffer
  scrolloff = 4,
  sidescrolloff = 8,
  encoding = 'UTF-8', -- Set the encoding type
  incsearch = true, -- Shows the match while typing
  inccommand = 'split',
  shiftround = true, -- Round indent
  undofile = true,
  undolevels = 10000,
  -- Indenting
  expandtab = true, -- convert tabs to spaces
  smartindent = true, -- make indenting smarter again
  tabstop = 2, -- insert 2 spaces for a tab
  softtabstop = 2,
  shiftwidth = 2, -- the number of spaces inserted for each indentation
  sessionoptions = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp', 'folds' },
  virtualedit = 'block', -- Allow cursor to move where there is no text in visual block mode
  wildmode = 'longest:full,full', -- Command-line completion mode
  grepprg = 'rg --vimgrep',
  fillchars = {
    foldopen = '',
    foldclose = '',
    fold = ' ',
    foldsep = ' ',
    diff = '╱',
    eob = ' ',
  },
  foldlevel = 99,
  winminwidth = 5, -- Minimum window width
  spelllang = { 'en' },
  splitkeep = 'screen',
  jumpoptions = 'view',
  smoothscroll = true,
}

for k, v in pairs(default_options) do
  vim.opt[k] = v
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

if vim.fn.has('nvim-0.11.0') == 1 then
  vim.o.completeopt = 'menuone,noinsert,fuzzy,popup'
  vim.o.completeitemalign = 'kind,abbr,menu'
else
  vim.o.completeopt = 'menuone,noinsert,popup'
end

-- vim.opt.listchars = {
--   tab = ' ',
--   trail = '·',
--   extends = '',
--   precedes = '',
-- }
--
-- vim.opt.diffopt = {
--   'internal',
--   'filler',
--   'closeoff',
-- }
--
-- vim.opt.fillchars = {
--   diff = '╱',
--   eob = ' ',
--   stl = ' ',
--   stlnc = ' ',
--   wbr = ' ',
--   horiz = '─',
--   horizup = '┴',
--   horizdown = '┬',
--   vert = '│',
--   vertleft = '┤',
--   vertright = '├',
--   verthoriz = '┼',
-- }
