return {
  -- correctly setup mason lsp / dap extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "delve",
        "gopls",
        "goimports",
        "golangci-lint",
        "golangci-lint-langserver", -- Wraps golangci-lint as a language server
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "ray-x/go.nvim",
    },
    opts = {
      servers = {
        golangci_lint_ls = {}, -- linter
        gopls = {
          gopls = function()
            local util = require("lspconfig/util")
            return {
              cmd = { "gopls", "serve" },
              filetypes = { "go", "gomod" },
              root_dir = util.root_pattern("go.work", "go.mod", ".git"),
              settings = {
                gopls = {
                  experimentalPostfixCompletions = true,
                  gofumpt = true,
                  codelenses = {
                    generate = true,
                    gc_details = true,
                    test = true,
                    tidy = true,
                  },
                  analyses = {
                    unusedparams = true,
                  },
                  staticcheck = true,
                },
              },
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                gofumpt = true
              }
            }
          end
        }
      },
      -- configure gopls and attach to golang ft
      setup = {
        gopls = function()
          require("go").setup({
            dap_debug = true,
            dap_debug_gui = true
          })
          return false
        end
      }
    }
  },
  -- setup DAP
  {
    "leoluz/nvim-dap-go",
    init = function()
      require("helper").on_ft("go", function(event)
        -- stylua: ignore start
        vim.keymap.set("n", "<leader>dt", function() require("dap-go").debug_test() end,
          { desc = "debug test", buffer = event.buf })
        vim.keymap.set("n", "<leader>dT", function() require("dap-go").debug_last_test() end,
          { desc = "debug last test", buffer = event.buf })
        -- stylua: ignore end
      end)
    end,
    config = function()
      require("dap-go").setup()
    end,
  },

  {
    "olexsmir/gopher.nvim",
    ft = "go",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  }
}
