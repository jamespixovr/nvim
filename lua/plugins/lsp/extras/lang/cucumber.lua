return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        cucumber_language_server = {
          cmd = { "cucumber-language-server", "--stdio" },
          filetypes = { "cucumber", "feature" },
        }
      }
    }
  }
}
