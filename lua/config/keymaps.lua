-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "

local keymap = vim.keymap.set

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
keymap("v", "p", '"_dp')

-- 'jk' for quitting insert mode
keymap("i", "jk", "<ESC>")
keymap("i", "kj", "<ESC>")


-- Move current line / block with Alt-j/k ala vscode.
-- keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Terminal Mappings
keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- Move current line / block with Alt-j/k ala vscode.
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==gi")
-- Move current line / block with Alt-j/k ala vscode.
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==gi")

-- navigation
keymap("i", "C-Up", "<C-\\><C-N><C-w>k")
keymap("i", "C-Down", "<C-\\><C-N><C-w>j")
keymap("i", "C-Left", "<C-\\><C-N><C-w>h")
keymap("i", "C-Right", "<C-\\><C-N><C-w>l")


-- Better window movement
-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

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

-- BASH-style movement in insert mode
keymap("i", "<C-a>", "<C-o>^")
keymap("i", "<C-e>", "<C-o>$")

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
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

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

-- toggle inlay hints
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>uh",
    function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle inlay hints" }
  )
end
