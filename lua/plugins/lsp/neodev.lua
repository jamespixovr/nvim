return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = {
        pathStrict = true,
      },
      library = {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }
    },
  },
}
