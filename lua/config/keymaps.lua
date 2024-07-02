---ensures unique keymaps https://www.reddit.com/r/neovim/comments/16h2lla/can_you_make_neovim_warn_you_if_your_config_maps/
---@param modes "n"|"v"|"x"|"i"|"o"|"c"|"t"|"ia"|"ca"|"!a"|string[]
---@param lhs string
---@param rhs string|function
---@param opts? { unique: boolean, desc: string, buffer: boolean, nowait: boolean, remap: boolean }
local function keymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  if opts.unique == nil then
    opts.unique = true
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "g,", "g,zvzz")
keymap("n", "g;", "g;zvzz")

-- Better indent
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP')

--[[-- jk is mapped to escape by better-escape.nvim plugin]]
-- 'jk' for quitting insert mode
-- keymap("i", "jk", "<ESC>")
-- keymap("i", "kj", "<ESC>")

-- COMMAND & INSERT MODE
keymap({ "i", "c" }, "<C-a>", "<Home>")
keymap({ "i", "c" }, "<C-e>", "<End>")

-- navigation
keymap("i", "<C-Up>", "<C-\\><C-N><C-w>k")
keymap("i", "<C-Down>", "<C-\\><C-N><C-w>j")
keymap("i", "<C-Left>", "<C-\\><C-N><C-w>h")
keymap("i", "<C-Right>", "<C-\\><C-N><C-w>l")

-- Terminal Mappings
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Better window movement
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- QuickFix
keymap("n", "]q", ":cnext<CR>")
keymap("n", "[q", ":cprev<CR>")
keymap("n", "<C-q>", ":call QuickFixToggle()<CR>")

-- Disable arrow keys
keymap("n", "<Up>", "<Nop>")
keymap("n", "<Down>", "<Nop>")
keymap("n", "<Left>", "<Nop>")
keymap("n", "<Right>", "<Nop>")

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
keymap("n", "<leader><space>", ":nohlsearch<CR>")

keymap("n", "<leader>bo", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- save file
-- keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- lazy
keymap("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- windows
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

keymap("x", "K", ":m '<-2<CR>gv-gv")
keymap("x", "J", ":m '>+1<CR>gv-gv")

-- QUICKFIX
keymap("n", "gq", vim.cmd.cnext, { desc = " Next Quickfix" })
keymap("n", "gQ", vim.cmd.cprevious, { desc = " Prev Quickfix" })
keymap("n", "dQ", function()
  vim.cmd.cexpr("[]")
end, { desc = " Delete Quickfix List" })

-- OPTION TOGGLING
-- toggle inlay hints
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(0, false)
  end, { desc = "Toggle inlay hints" })
end

keymap("n", "<leader>cu", function()
  vim.cmd("silent later " .. tostring(vim.opt.undolevels:get()))
end, { desc = "󰛒 Redo All" })
