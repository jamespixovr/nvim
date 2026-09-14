local filetypes = {
  'cs',
  'dockerfile',
  'docker',
  'go',
  'html',
  'java',
  'javascript',
  'javascriptreact',
  'php',
  'python',
  'typescript',
  'typescriptreact',
  'vue',
}

return {
  {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    ft = filetypes,
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = function()
      return {
        server = {
          cmd = vim
            .iter({
              require('helpers.jvm').home(21) .. '/bin/java',
              '-jar',
              vim.fn.expand('$MASON/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar'),
              '-stdio',
              '-analyzers',
              vim.fn.expand('$MASON/share/sonarlint-analyzers/*.jar', true, 1),
            })
            :flatten()
            :totable(),
        },

        filetypes = filetypes,
      }
    end,
  },
}
