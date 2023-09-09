local util = require("lspconfig/util")
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
    opts = {
      servers = {
        golangci_lint_ls = {}, -- linter
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = util.root_pattern("go.work", "go.mod", ".git"),
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        }
      },
      -- configure gopls and attach to golang ft
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          require("helper").on_lsp_attach(function(client, _)
            if client.name == "gopls" then
              if not client.server_capabilities.semanticTokensProvider then
                local semantic = client.config.capabilities.textDocument.semanticTokens
                client.server_capabilities.semanticTokensProvider = {
                  full = true,
                  legend = {
                    tokenTypes = semantic.tokenTypes,
                    tokenModifiers = semantic.tokenModifiers,
                  },
                  range = true,
                }
              end
            end
          end)
          -- end workaround
        end,
      }
    }
  },

  {
    "ray-x/go.nvim",
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        dap_debug = true,
        dap_debug_gui = true
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    -- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
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
