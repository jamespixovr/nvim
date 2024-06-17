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
          "sonarlint-language-server",
          -- mason .. "/bin/sonarlint-language-server",
          -- Ensure that sonarlint-language-server uses stdio channel
          "-stdio",
          "-analyzers",
          -- paths to the analyzers you need, using those for python and java in this example
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjs.jar"),
          vim.fn.expand("$MASON/share/sonarlint-analyzers/sonargo.jar"),
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
