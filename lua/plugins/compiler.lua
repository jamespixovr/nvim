return {
  --  COMPILER ----------------------------------------------------------------
  --  compiler.nvim [compiler]
  --  https://github.com/Zeioth/compiler.nvim
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = function()
      vim.g.NODEJS_PACKAGE_MANAGER = "pnpm"
      return {}
    end,
    keys = {
      { "<leader>lo", "<cmd>CompilerOpen<cr>", desc = "Compi[l]er [o]pen" },
      { "<leader>lr", "<cmd>CompilerRedo<cr>", desc = "Compi[l]er [r]edo" },
    },
  },

  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    "andythigpen/nvim-coverage",
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageLoadLcov",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    config = function()
      require("coverage").setup()
    end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}
