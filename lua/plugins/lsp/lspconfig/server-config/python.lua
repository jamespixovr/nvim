return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {},
        ruff_lsp = {},
      },
    },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   optional = true,
  --   dependencies = {
  --     "nvim-neotest/neotest-python",
  --   },
  --   opts = {
  --     adapters = {
  --       ["neotest-python"] = {
  --         -- Here you can specify the settings for the adapter, i.e.
  --         -- runner = "pytest",
  --         -- python = ".venv/bin/python",
  --       },
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   dependencies = {
  --     "mfussenegger/nvim-dap-python",
  --     -- stylua: ignore
  --     keys = {
  --       { "<leader>dM", function() require('dap-python').test_method() end, desc = "Debug Method" },
  --       { "<leader>dN", function() require('dap-python').test_class() end,  desc = "Debug Class" },
  --     },
  --     config = function()
  --       local path = require("mason-registry").get_package("debugpy"):get_install_path()
  --       require("dap-python").setup(path .. "/venv/bin/python")
  --     end,
  --   },
  -- },
  -- {
  --   "linux-cultist/venv-selector.nvim",
  --   event = "VeryLazy",
  --   cmd = "VenvSelect",
  --   opts = {
  --     name = {
  --       "venv",
  --       ".venv",
  --       "env",
  --       ".env",
  --     },
  --   },
  --   keys = {
  --     { "<leader>vs", "<cmd>:VenvSelect<cr>",       desc = "Select VirtualEnv" },
  --     { "<leader>vc", "<cmd>:VenvSelectCached<cr>", desc = "Select VirtualEnv" }
  --   },
  -- },
}
