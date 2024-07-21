local function augroup(name)
  return vim.api.nvim_create_augroup("jarmex_neovim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end,
})

local present, lualine = pcall(require, "lualine")
if present then
  local macro_refresh_places = { "statusline" }
  vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
      lualine.refresh({
        place = macro_refresh_places,
      })
    end,
  })

  vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
      lualine.refresh({
        place = macro_refresh_places,
      })
    end,
  })
end

local group = vim.api.nvim_create_augroup("__env", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = ".env",
  group = group,
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.graphql,*.graphqls,*.gql",
  callback = function()
    vim.bo.filetype = "graphql"
  end,
  once = false,
})

-- Define local variables
local autocmd = vim.api.nvim_create_autocmd
local user_cmd = vim.api.nvim_create_user_command

-- Check for spelling in text filetypes and enable wrapping, and set gj and gk keymaps
autocmd("FileType", {
  group = augroup("set_wrap"),
  pattern = {
    "gitcommit",
    "markdown",
    "text",
  },
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_keymap(0, "n", "j", "gj", opts)
    vim.api.nvim_buf_set_keymap(0, "n", "k", "gk", opts)
  end,
})
-- local mapfile = " "
user_cmd("BiPolar", function(_)
  local moods_table = {
    ["true"] = "false",
    ["false"] = "true",
    ["on"] = "off",
    ["off"] = "on",
    ["Up"] = "Down",
    ["Down"] = "Up",
    ["up"] = "down",
    ["down"] = "up",
    ["enable"] = "disable",
    ["disable"] = "enable",
    ["no"] = "yes",
    ["yes"] = "no",
  }
  local cursor_word = vim.api.nvim_eval("expand('<cword>')")
  if moods_table[cursor_word] then
    vim.cmd("normal ciw" .. moods_table[cursor_word] .. "")
  end
end, {
  desc = "Switch Moody Words",
  force = true,
})
