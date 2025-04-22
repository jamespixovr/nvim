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
        require('conform').format({ async = false, timeout_ms = 5000, lsp_fallback = true })
      end,
      mode = { 'n', 'v' },
      desc = 'Format file or range (in visual mode)',
    },
    {
      '<leader>cM',
      function()
        require('conform').format({ formatters = { 'injected' }, timeout_ms = 3000 })
      end,
      mode = { 'n', 'v' },
      desc = 'Format Injected Langs',
    },
    {
      '<leader>cm',
      function()
        require('conform').format()
      end,
      mode = { 'n', 'v' },
      desc = 'Format',
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
      cs = { 'csharpier' },
      -- cs = "dotnet-csharpier",
      css = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      -- go = { 'goimports', 'gci', 'gofumpt', 'golines' },
      graphql = { 'biome', 'prettierd', 'prettier', stop_after_first = true },
      handlebars = { 'prettier' },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'biome' },
      javascriptreact = { 'biome' },
      json = { 'biome' },
      json5 = { 'biome' },
      jsonc = { 'biome' },
      lua = { 'stylua' },
      markdown = { 'markdownlint', 'markdown-toc', stop_after_first = true },
      python = { 'isort', 'black', stop_after_first = true },
      sh = { 'shfmt' },
      sql = { 'sql_formatter' },
      typescript = { 'biome' },
      typescriptreact = { 'biome' },
      -- yaml = { 'prettier' },
      xml = { 'xmlformatter' },
      -- https://github.com/google/yamlfmt
      yaml = { 'yamlfmt' },
      -- ["*"] = { "trim_whitespace" },
    },
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = {}
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match('/node_modules/') then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters = {
      -- biome = {
      --   -- https://biomejs.dev/formatter/
      --   args = { 'format', '--indent-style', 'space', '--stdin-file-path', '$FILENAME' },
      -- },
      injected = { options = { ignore_errors = true } },
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
      yamlfmt = {
        prepend_args = {
          -- https://github.com/google/yamlfmt/blob/main/docs/config-file.md#configuration-1
          '-formatter',
          'retain_line_breaks_single=true',
          'include_document_start=true',
        },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
