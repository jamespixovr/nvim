---@type vim.lsp.Config
local config = {
  filetypes = { 'markdown', 'text', 'tex', 'typst', 'html', 'javascriptreact', 'typescriptreact' },
  settings = {
    ['harper-ls'] = {
      codeActions = {
        forceStable = true,
      },
      diagnosticSeverity = 'hint',
      userDictPath = vim.o.spellfile, -- share it with vim's spellcheck
      markdown = { IgnoreLinkTitle = true },
      dialect = 'American',
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
  on_attach = function(_client, bufnr)
    local function addToDict(which)
      vim.lsp.buf.code_action({
        filter = function(a)
          return a.command == ('HarperAddTo%sDict'):format(which)
        end,
        apply = true,
      })
      vim.notify(('Added to %s dict.'):format(which))
    end

    Keymap({
      'zg',
      function()
        addToDict('WS')
      end,
      desc = '󰓆 Workspace dict',
      buf = bufnr,
    })
    Keymap({
      'zG',
      function()
        addToDict('User')
      end,
      desc = '󰓆 User dict',
      buf = bufnr,
    })
  end,
}

return config
