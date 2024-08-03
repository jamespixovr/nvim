return {
  {
    "mfussenegger/nvim-lint",
    event = "BufReadPre",
    config = function()
      require("lint").linters_by_ft = {
        python = { "ruff" },
        htmldjango = { "djlint" },
        lua = { "selene" },
        markdown = { "markdownlint" },
        ["css"] = { "stylelint" },
        ["scss"] = { "stylelint" },
        ["less"] = { "stylelint" },
        -- lua = { "selene", "luacheck" },
        -- typescript = { "biomejs", "eslint_d", "eslint" },
        -- javascript = { "biomejs", "eslint_d", "eslint" },
        -- typescriptreact = { "biomejs", "eslint_d", "eslint" },
        -- javascriptreact = { "biomejs", "eslint_d", "eslint" },
        -- svelte = { "eslint_d" },
        sql = { "sqlfluff" },
        yaml = { "yamllint" },
      }

      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "BufReadPost" }, {
        callback = function()
          local lint_status, lint = pcall(require, "lint")
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
