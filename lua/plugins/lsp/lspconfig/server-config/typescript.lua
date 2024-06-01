local nodeDapConfig = require("plugins.dap.typescript").nodeDapConfig

return {
  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx" })
      end
    end,
  },
  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of typescript-tools below.
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },

  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "dmmulroy/ts-error-translator.nvim",
    },
    keys = {
      { "<leader>li", "<cmd>TSToolsOrganizeImports<cr>",     desc = "[L]SP Organize [I]mports" },
      { "<leader>la", "<cmd>TSToolsAddMissingImports<cr>",   desc = "[L]SP Add [A]dd Missing Imports" },
      { "<leader>lu", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "[L]SP Remove [U]nused Imports" },
      { "<leader>lx", "<cmd>TSToolsFixAll<cr>",              desc = "Fi[x] fixable errors" },
    },
    ft = { 'javascriptreact', 'typescriptreact', 'javascript.jsx', 'typescript.tsx', 'javascript', 'typescript' },
    config = function()
      local api = require("typescript-tools.api")
      require("typescript-tools").setup {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
            require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
            api.filter_diagnostics({ 80006, 80001 })(err, result, ctx, config)
          end,

        },
        settings = {
          code_lens = "all",
          expose_as_code_action = "all",
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
          tsserver_file_preferences = {
            completions = {
              completeFunctionCalls = true,
            },
            init_options = {
              preferences = {
                disableSuggestions = true,
              },
            },
            includeCompletionsForModuleExports = true,
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayParameterNameHints = "all", -- none | literals | all
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayVariableTypeHints = true,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          },
          tsserver_plugins = {
            -- https://github.com/styled-components/typescript-styled-plugin
            -- for TypeScript v4.9+
            '@styled/typescript-styled-plugin',
            -- or for older TypeScript versions
            -- "typescript-styled-plugin",
          },
        },
      }
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")

      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      local languages = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue' }
      for _, language in ipairs(languages) do
        if not dap.configurations[language] then
          dap.configurations[language] = nodeDapConfig(language)
        end
      end
    end,
  },

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      { "haydenmeade/neotest-jest", version = false },
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jest_test_discovery = false,
          jestCommand = "pnpm test --",
          jestConfigFile = function()
            local file = vim.fn.expand('%:p')
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src") .. "jest.config.ts"
            end

            return vim.fn.getcwd() .. "/jest.config.ts"
          end,
          env = { CI = true },
          cwd = function(_path)
            local file = vim.fn.expand('%:p')
            if string.find(file, "/packages/") then
              return string.match(file, "(.-/[^/]+/)src")
            end
            return vim.fn.getcwd()
          end,
        },
      },
    },
  }
}
