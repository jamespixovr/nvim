return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- Make sure mason installs the server
      servers = {
        harper_ls = {
          settings = {
            ['harper-ls'] = {
              codeActions = {
                forceStable = true,
              },
              linters = {
                spell_check = true,
                spelled_numbers = true,
                an_a = true,
                sentence_capitalization = true,
                unclosed_quotes = true,
                wrong_quotes = false,
                long_sentences = true,
                repeated_words = true,
                spaces = true,
                matcher = true,
                linking_verbs = true,
                boring_words = true,
              },
              isolateEnglish = false,
            },
          },
        },
      },
    },
  },
}
