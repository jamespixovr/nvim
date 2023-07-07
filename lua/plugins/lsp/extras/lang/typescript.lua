-- https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
local jsAndTsSettings = {
  format = {}, -- not used, since taken care of by prettier
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all", -- none | literals | all
    includeInlayParameterNameHintsWhenArgumentMatchesName = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  },
  suggest = {
    includeCompletionsForModuleExports = true,
  },
}

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
  -- typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          on_attach = function(_, bufnr)
            -- stylua: ignore
            vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<cr>",
              { desc = "Organize Imports", buffer = bufnr })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<cr>",
              { desc = "Remove Unused", buffer = bufnr })
            -- stylua: ignore
            vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File", buffer = bufnr })
          end,
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "project-relative",
            }
          },
          settings = {
            completions = {
              completeFunctionCalls = true,
            },
            diagnostics = {
              ignoredCodes = { 80001 },
            },
            typescript = jsAndTsSettings,
            javascript = jsAndTsSettings,
          },
        },
      },
      setup = {
        tsserver = function(_, config)
          require("typescript").setup({ server = config })
          return true
        end,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
    end,
  },
}
