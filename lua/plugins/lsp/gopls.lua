local util = require("lspconfig/util")

return {
  cmd = { "gopls", "serve" },
  filetypes = { "go", "gomod" },
  root_dir = util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      experimentalPostfixCompletions = true,
      gofumpt = true,
      codelenses = {
        generate = true,
        gc_details = true,
        test = true,
        tidy = true,
      },
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
    },
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    gofumpt = true
  }
}
