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
    "davidosomething/format-ts-errors.nvim", -- extracted ts error formatter
    lazy = true,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          keys = {
            {
              "<leader>co",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.organizeImports.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>cR",
              function()
                vim.lsp.buf.code_action({
                  apply = true,
                  context = {
                    only = { "source.removeUnused.ts" },
                    diagnostics = {},
                  },
                })
              end,
              desc = "Remove Unused Imports",
            },
          },
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "project-relative",
            }
          },
          handlers = {
            ["textDocument/publishDiagnostics"] = function(
              _,
              result,
              ctx,
              config
            )
              if result.diagnostics == nil then
                return
              end

              -- ignore some tsserver diagnostics
              local idx = 1
              while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]

                local formatter = require("format-ts-errors")[entry.code]
                entry.message = formatter and formatter(entry.message)
                    or entry.message

                -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                if entry.code == 80001 then
                  -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end

              vim.lsp.diagnostic.on_publish_diagnostics(
                _,
                result,
                ctx,
                config
              )
            end,
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
    },
  },

}
