local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = "plugins",
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "getscriptPlugin",
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimballPlugin",
        "zipPlugin",
      },
    },
  },
})
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")
