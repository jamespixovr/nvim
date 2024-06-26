local linterConfig = vim.fn.stdpath("config") .. ".linter_configs"

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  dependencies = { "mason.nvim" },
  keys = {
    {
      "<leader>fd",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    format = {
      timeout_ms = 3000,
      async = false, -- not recommended to change
      quiet = false, -- not recommended to change
      lsp_fallback = true, -- not recommended to change
    },
    formatters_by_ft = {
      css = { { "prettierd", "prettier" } },
      graphql = { { "prettierd", "prettier" } },
      html = { { "prettierd", "prettier" } },
      javascript = { "biome" },
      javascriptreact = { "biome" },
      typescript = { "biome" },
      typescriptreact = { "biome" },
      -- javascript = { { "prettierd", "prettier" } },
      -- javascriptreact = { { "prettierd", "prettier" } },
      json = { "jq" },
      handlebars = { "prettier" },
      -- json = { { "prettierd", "prettier" } },
      lua = { "stylua" },
      markdown = { "markdownlint" },
      python = { "isort", "black" },
      sql = { "sql-formatter" },
      svelte = { { "prettierd", "prettier" } },
      -- typescript = { { "prettierd", "prettier" } },
      -- typescriptreact = { { "prettierd", "prettier" } },
      yaml = { "prettier" },
    },
    format_on_save = { timeout_ms = 500, lsp_fallback = true },
    formatters = {
      markdownlint = {
        command = "markdownlint",
        stdin = false,
        args = { "--fix", "--config", linterConfig .. "/markdownlint.yaml", "$FILENAME" },
      },
      sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      },
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
