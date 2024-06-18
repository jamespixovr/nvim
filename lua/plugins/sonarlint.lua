return {
  url = "https://gitlab.com/schrieveslaach/sonarlint.nvim",
  enabled = false,
  ft = { "python", "javascript", "go", "typescript", "javascriptreact", "typescriptreact" },
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  config = function()
    -- local mason = vim.fn.stdpath "data" .. "/mason"
    require("sonarlint").setup({
      server = {
        cmd = {
          "/opt/homebrew/opt/openjdk@17/bin/java",
          "-jar",
          vim.fn.expand("$MASON/packages/sonarlint-language-server/extension/server/sonarlint-ls.jar"),
          "-stdio",
          "-analyzers",
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarhtml.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
          -- vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarphp.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonartext.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarxml.jar"),
        },
      },
      filetypes = {
        -- Tested and working
        "python",
        "go",
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
      },
    })
  end,
}
