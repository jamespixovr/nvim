return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      -- Event to trigger linters
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        typescript = { "biomejs", "eslint_d", "eslint" },
        javascript = { "biomejs", "eslint_d", "eslint" },
        typescriptreact = { "biomejs", "eslint_d", "eslint" },
        javascriptreact = { "biomejs", "eslint_d", "eslint" },
        svelte = { "eslint_d" },
        python = { "pylint" },
        sql = { "sqlfluff" },
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      require("lint").linters = opts.linters

      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
