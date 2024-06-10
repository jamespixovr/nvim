-- spellchecker for code
-- TYPOS
-- DOCS https://github.com/tekumara/typos-lsp/blob/main/docs/neovim-lsp-config.md
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        typos_lsp = {
          init_options = { diagnosticSeverity = "Info" },
        },
      },
    },
  },
}
