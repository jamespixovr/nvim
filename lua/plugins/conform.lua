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
      css = { 'prettierd', stop_after_first = true },
      graphql = { 'prettierd', stop_after_first = true },
      handlebars = { 'prettierd' },
      html = { 'prettierd', stop_after_first = true },
      json = { 'jq' },
      lua = { 'stylua' },
      markdown = { 'markdownlint', 'markdown-toc', stop_after_first = true },
      python = { 'isort', 'black', stop_after_first = true },
      -- sql = { "sql-formatter" },
      yaml = { 'prettierd' },
      -- ["*"] = { "trim_whitespace" },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters = {
      markdownlint = {
        command = 'markdownlint',
        stdin = false,
        args = { '--fix', '--config', linterConfig .. '/markdownlint.yaml', '$FILENAME' },
      },
      sqlfluff = {
        args = { 'format', '--dialect=ansi', '-' },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
