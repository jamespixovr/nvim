---@type vim.lsp.Config
local config = {
  filetypes = { 'markdown', 'text', 'tex', 'typst', 'html', 'javascriptreact', 'typescriptreact' },
  settings = {
    ['harper-ls'] = {
      codeActions = {
        forceStable = true,
      },
      -- userDictPath = "",
      -- workspaceDictPath = "",
      -- fileDictPath = "",
      linters = {
        SpellCheck = true,
        SpelledNumbers = true,
        AnA = true,
        SentenceCapitalization = false,
        UnclosedQuotes = true,
        WrongApostrophe = false,
        LongSentences = false,
        RepeatedWords = true,
        Spaces = false,
        CorrectNumberSuffix = false,
      },
      -- isolateEnglish = false,
    },
  },
}

return config
