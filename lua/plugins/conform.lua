local linterConfig = vim.fn.stdpath('config') .. '/.linter_configs'

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  dependencies = { 'mason.nvim' },
  keys = {
    {
      '<leader>fd',
      function()
        require('conform').format({ async = true, lsp_fallback = true })
      end,
      desc = 'Format buffer',
    },
  },
  opts = {
    format = {
      timeout_ms = 3000,
      async = true, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_fallback = true, -- not recommended to change
    },
    formatters_by_ft = {
      -- cs = { 'csharpier' },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      graphql = { 'prettierd', 'prettier', stop_after_first = true },
      -- go = { 'goimports', 'gofumpt', 'golines' },
      -- go = { 'goimports', 'gci', 'gofumpt', 'golines' },
      handlebars = { 'prettier' },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'jq' },
      lua = { 'stylua' },
      markdown = { 'markdownlint', 'markdown-toc', stop_after_first = true },
      python = { 'isort', 'black', stop_after_first = true },
      sql = { 'sql-formatter' },
      sh = { 'shfmt' },
      yaml = { 'prettier' },
      -- ["*"] = { "trim_whitespace" },
    },
    format_on_save = { timeout_ms = 2000, lsp_fallback = true },
    formatters = {
      csharpier = {
        command = 'dotnet-csharpier',
        args = { '--write-stdout' },
      },
      markdownlint = {
        command = 'markdownlint',
        stdin = false,
        args = { '--fix', '--config', linterConfig .. '/markdownlint.yaml', '$FILENAME' },
      },
      sqlfluff = {
        args = { 'format', '--dialect=ansi', '-' },
      },
      goimports = {
        -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/goimports.lua
        args = { '-srcdir', '$FILENAME' },
      },
      gci = {
        -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gci.lua
        args = { 'write', '--skip-generated', '-s', 'standard', '-s', 'default', '--skip-vendor', '$FILENAME' },
      },
      gofumpt = {
        -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gofumpt.lua
        prepend_args = { '-extra', '-w', '$FILENAME' },
        stdin = false,
      },
      golines = {
        -- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/golines.lua
        -- NOTE: golines will use goimports as base formatter by default which can be slow.
        -- see https://github.com/segmentio/golines/issues/33
        prepend_args = { '--base-formatter=gofumpt', '--ignore-generated', '--tab-len=1', '--max-len=150' },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
