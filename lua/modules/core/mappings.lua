-- adapted from https://github.com/LunarVim/LunarVim/blob/rolling/lua/lvim/keymappings.lua
local M = {}
local generic_opts_any = { noremap = true, silent = true }

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
}

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	term_mode = { silent = true },
}

-- Set key mappings individually
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param key The key of keymap
-- @param val Can be form as a mapping or tuple of mapping and user defined opt
function M.set_keymaps(mode, key, val)
	local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
	if type(val) == "table" then
		opt = val[2]
		val = val[1]
	end
	vim.api.nvim_set_keymap(mode, key, val, opt)
end

-- Load key mappings for a given mode
-- @param mode The keymap mode, can be one of the keys of mode_adapters
-- @param keymaps The list of key mappings
function M.load_mode(mode, keymaps)
	mode = mode_adapters[mode] and mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M.set_keymaps(mode, k, v)
	end
end

-- Load key mappings for all provided modes
-- @param keymaps A list of key mappings for each mode
function M.load(keymaps)
	for mode, mapping in pairs(keymaps) do
		M.load_mode(mode, mapping)
	end
end

function M.config()
	local mykeys = {
		---@usage change or add keymappings for insert mode
		insert_mode = {
			-- 'jk' for quitting insert mode
			["jk"] = "<ESC>",
			-- 'kj' for quitting insert mode
			["kj"] = "<ESC>",
			-- 'jj' for quitting insert mode
			["jj"] = "<ESC>",
			-- Move current line / block with Alt-j/k ala vscode.
			["<A-j>"] = "<Esc>:m .+1<CR>==gi",
			-- Move current line / block with Alt-j/k ala vscode.
			["<A-k>"] = "<Esc>:m .-2<CR>==gi",
			-- navigation
			["<C-Up>"] = "<C-\\><C-N><C-w>k",
			["<C-Down>"] = "<C-\\><C-N><C-w>j",
			["<C-Left>"] = "<C-\\><C-N><C-w>h",
			["<C-Right>"] = "<C-\\><C-N><C-w>l",
		},

		---@usage change or add keymappings for normal mode
		normal_mode = {
			-- Better window movement
			["<C-h>"] = "<C-w>h",
			["<C-j>"] = "<C-w>j",
			["<C-k>"] = "<C-w>k",
			["<C-l>"] = "<C-w>l",

			-- Resize with arrows
			["<C-Up>"] = ":resize -2<CR>",
			["<C-Down>"] = ":resize +2<CR>",
			["<C-Left>"] = ":vertical resize -2<CR>",
			["<C-Right>"] = ":vertical resize +2<CR>",

			-- Move current line / block with Alt-j/k a la vscode.
			--[[ ["<A-j>"] = ":m .+1<CR>==",
      ["<A-k>"] = ":m .-2<CR>==", ]]

			-- QuickFix
			["]q"] = ":cnext<CR>",
			["[q"] = ":cprev<CR>",
			["<C-q>"] = ":call QuickFixToggle()<CR>",

			-- Disable arrow keys
			["<Up>"] = "<Nop>",
			["<Down>"] = "<Nop>",
			["<Left>"] = "<Nop>",
			["<Right>"] = "<Nop>",

			-- Auto center on matched string.
			["n"] = "nzz",
			["N"] = "Nzz",
			["<leader><space>"] = ":nohlsearch<CR>",
		},

		---@usage change or add keymappings for terminal mode
		term_mode = {
			-- Terminal window navigation
			["<C-h>"] = "<C-\\><C-N><C-w>h",
			["<C-j>"] = "<C-\\><C-N><C-w>j",
			["<C-k>"] = "<C-\\><C-N><C-w>k",
			["<C-l>"] = "<C-\\><C-N><C-w>l",
		},

		---@usage change or add keymappings for visual mode
		visual_mode = {
			-- Better indenting
			["<"] = "<gv",
			[">"] = ">gv",
			["p"] = '"_dP',
		},

		---@usage change or add keymappings for visual block mode
		visual_block_mode = {
			-- Move selected line / block of text in visual mode
			["K"] = ":move '<-2<CR>gv-gv",
			["J"] = ":move '>+1<CR>gv-gv",
		},

		---@usage change or add keymappings for command mode
		command_mode = {
			-- navigate tab completion with <c-j> and <c-k>
			-- runs conditionally
			["<C-j>"] = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } },
			["<C-k>"] = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } },
		},
	}
	return mykeys
end

function M.setup()
	M.set_keymaps("", "<Space>", "<Nop>")
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	local getconfig = M.config()
	M.load(getconfig)
end

-- return M
M.setup()
