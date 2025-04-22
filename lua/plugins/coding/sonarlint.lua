local filetypes = { 'java', 'python', 'php', 'javascript', 'typescript', 'vue', 'go' }

return {
  {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    ft = filetypes,
    dependencies = {
      'neovim/nvim-lspconfig',
    },
    config = function()
      require('sonarlint').setup({
        server = {
          cmd = vim
            .iter({
              -- '/opt/homebrew/opt/openjdk@17/bin/java',
              require('lib.jvm').home(17) .. '/bin/java',
              -- "-agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=*:5005",
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
      })
    end,
  },
}
