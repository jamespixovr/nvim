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

local ignore_filetypes =
  { "OverseerList", "NvimTree", "Outline", "Diffview*", "Dressing*", "Neogit*", "alpha", "dapui*" }
local augroup = vim.api.nvim_create_augroup("FocusDisable", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  callback = function(_)
    if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
      vim.b.focus_disable = true
    else
      vim.b.focus_disable = false
    end
  end,
  desc = "Disable focus autoresize for FileType",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.graphql,*.graphqls,*.gql",
  callback = function()
    vim.bo.filetype = "graphql"
  end,
  once = false,
})
