return {
  -- formatters
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = { "mason.nvim" },
    opts = function()
      local util = require("helper")
      local nls = require("null-ls")
      local fmt = nls.builtins.formatting
      local dgn = nls.builtins.diagnostics
      local cda = nls.builtins.code_actions
      local command_resolver = require("null-ls.helpers.command_resolver")

      return {
        debounce = 150,
        save_after_format = true,
        border = "rounded",
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          --  ╭────────────╮
          --  │ Formatting │
          --  ╰────────────╯
          fmt.prettier.with({
            dynamic_command = command_resolver.from_node_modules(),
          }),
          fmt.shfmt.with({
            filetypes = { 'sh', 'zsh' },
          }),
          fmt.tidy,
          fmt.stylua.with({
            condition = function()
              return util.executable("stylua", true)
                  and not vim.tbl_isempty(vim.fs.find({ ".stylua.toml", "stylua.toml" }, {
                    path = vim.fn.expand("%:p"),
                    upward = true,
                  }))
            end,
          }),
          fmt.buf,       --PROTO
          fmt.pg_format,
          fmt.gofumpt,   -- GO
          fmt.goimports, --GO

          -- fmt.biome.with({
          --   args = {
          --     'check',
          --     '--apply-unsafe',
          --     '--formatter-enabled=true',
          --     '--organize-imports-enabled=true',
          --     '--skip-errors',
          --     '$FILENAME',
          --   },
          -- }),

          --  ╭─────────────╮
          --  │ Diagnostics │
          --  ╰─────────────╯
          dgn.yamllint.with({ extra_filetypes = { "yml" } }), -- add support for yml extensions
          dgn.tidy,                                           -- xml
          dgn.buf.with({
            -- PROTO
            condition = function()
              return util.executable("buf", true)
            end,
          }),
          dgn.hadolint,      -- dockerfile
          dgn.dotenv_linter, --ENV
          dgn.markdownlint.with({
            condition = function()
              return util.executable("markdownlint", true)
            end,
          }),
          dgn.shellcheck.with({
            condition = function()
              return util.executable("shellcheck", false)
            end,
          }),

          --  ╭──────────────╮
          --  │ Code Actions │
          --  ╰──────────────╯
          cda.shellcheck.with({
            condition = function()
              return util.executable("shellcheck", true)
            end,
          }),
          cda.impl,
          -- typescript nvim
          -- require("typescript.extensions.null-ls.code-actions"),
        },
      }
    end,
  },
}
