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
}
