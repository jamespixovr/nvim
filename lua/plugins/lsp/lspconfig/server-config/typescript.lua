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
          tsserver_file_preferences = {
            includeInlayEnumMemberValueHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayParameterNameHints = "all", -- none | literals | all
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeCompletionsForModuleExports = true,
          },
          tsserver_plugins = {
            -- https://github.com/styled-components/typescript-styled-plugin
            -- for TypeScript v4.9+
            '@styled/typescript-styled-plugin',
            -- or for older TypeScript versions
            -- "typescript-styled-plugin",
          },
          separate_diagnostic_server = true,
        },
      }
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
          jestCommand = "pnpm exec jest",
          -- jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(_path)
            return vim.fn.getcwd()
          end,
        },
      },
    },
  }
}
