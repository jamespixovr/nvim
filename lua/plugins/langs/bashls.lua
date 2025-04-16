return {
  'neovim/nvim-lspconfig',
  ft = { 'sh' },
  opts = {
    servers = {
      -- https://github.com/bash-lsp/bash-language-server
      bashls = {},
    },
  },
}
