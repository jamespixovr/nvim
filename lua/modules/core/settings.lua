--  ╭─────────────────╮
--  │ Default plugins │
--  ╰─────────────────╯
-- Stop loading built in plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.wo.colorcolumn = "99999"

---  SETTINGS  ---
local default_options = {
	backspace = { "indent", "eol", "start" },
	backup = false, -- creates a backup file
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	colorcolumn = "99999", -- fixes indentline for now
	completeopt = { "menuone", "noselect" },
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the encoding written to a file
	foldenable = true, -- Enable folding
	-- changed from manual to expr. Adapted from https://github.com/abzcoding/nvim/blob/main/lua/options.lua
	foldlevel = 99, -- Fold by default, -- Using ufo provider need a large value, feel free to decrease the value
	foldmethod = "expr", -- folding, set to "expr" for treesitter based folding
	foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
	foldlevelstart = 99,
	foldcolumn = "1",
	-- fold end
	hidden = true, -- required to keep multiple buffers and open multiple buffers
	hlsearch = true, -- highlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore (dont show mode since we have a statusline)
	showtabline = 2, -- always show tabs
	smartcase = true, -- smart case
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeout = true, -- This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received. This is on by default but being explicit!
	timeoutlen = 500, -- Time in milliseconds to wait for a mapped sequence to complete.
	ttimeoutlen = 10, -- Time in milliseconds to wait for a key code sequence to complete
	updatetime = 280, -- If in this many milliseconds nothing is typed, the swap file will be written to disk. Also used for CursorHold autocommand (JARMEX = 300)
	-- wildmode = "list:longest", -- Command-line completion mode
	wildignore = { "*/.git/*", "*/node_modules/*" }, -- Ignore these files/folders

	title = true, -- set the title of window to the value of the titlestring
	-- opt.titlestring = "%<%F%=%l/%L - nvim" -- what the title of the window will be set to
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 2, -- the number of spaces inserted for each indentation
	tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	laststatus = 3,
	relativenumber = true, -- set relative numbered lines
	numberwidth = 2, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	spell = false,
	spelllang = "en",
	scrolloff = 4,
	sidescrolloff = 4,
	encoding = "UTF-8", -- Set the encoding type
	incsearch = true, -- Shows the match while typing
	shiftround = true, -- Round indent
	shada = "!,'100,<50,s10,h,:1000,/1000",
}

local function load_options()
	vim.cmd([[set iskeyword+=-]])
	for k, v in pairs(default_options) do
		vim.opt[k] = v
	end

	-- Create folders for our backups, undos, swaps and sessions if they don't exist
	vim.cmd("silent call mkdir(stdpath('data').'/backups', 'p', '0700')")
	vim.cmd("silent call mkdir(stdpath('data').'/undos', 'p', '0700')")
	vim.cmd("silent call mkdir(stdpath('data').'/swaps', 'p', '0700')")
	vim.cmd("silent call mkdir(stdpath('data').'/sessions', 'p', '0700')")

	vim.opt.backupdir = vim.fn.stdpath("data") .. "/backups" -- Use backup files
	vim.opt.directory = vim.fn.stdpath("data") .. "/swaps" -- Use Swap files
	vim.opt.undofile = true -- Maintain undo history between sessions
	vim.opt.undolevels = 10000 -- Ensure we can undo a lot!
	vim.opt.undodir = vim.fn.stdpath("data") .. "/undos" -- Set the undo directory

	vim.opt.shortmess:append("c")
	vim.opt.shortmess = vim.opt.shortmess + "A" -- ignore annoying swapfile messages
	vim.opt.shortmess = vim.opt.shortmess + "I" -- no splash screen
	vim.opt.shortmess = vim.opt.shortmess + "O" -- file-read message overwrites previous
	vim.opt.shortmess = vim.opt.shortmess + "T" -- truncate non-file messages in middle
	vim.opt.shortmess = vim.opt.shortmess + "W" -- don't echo "[w]"/"[written]" when writing
	vim.opt.shortmess = vim.opt.shortmess + "a" -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
	vim.opt.shortmess = vim.opt.shortmess + "c" -- completion messages
	vim.opt.shortmess = vim.opt.shortmess + "o" -- overwrite file-written messages
	vim.opt.shortmess = vim.opt.shortmess + "t" -- truncate file messages at start

	vim.opt.fillchars = {
		foldopen = "",
		foldclose = "",
		fold = " ",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	}

	vim.cmd([[
    filetype indent plugin on
    syntax enable
  ]])
end

-- call the function
load_options()
