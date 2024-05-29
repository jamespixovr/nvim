return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = { virtual_text = true },
      servers = {
        graphql = {
          filetypes = { "graphql", "typescript", "typescriptreact" },
        },
      },
    },
  }
}
