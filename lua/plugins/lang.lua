return {
  -- typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function(_, opts)
          local server_opts = opts or {}
          server_opts = vim.tbl_deep_extend("force", server_opts, {
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
              javascript = {
                inlayHints = {
                  includeInlayParameterNameHints = "all",
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                },
              },
            }
          })
          require("typescript").setup({
            debug = false,     -- enable debug logging for commands
            go_to_source_definition = {
              fallback = true, -- fall back to standard LSP definition on failure
            },
            server = server_opts
          })
          return true
        end
      }
    },
  },
  -- json
  {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/SchemaStore.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
  -- RUST
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
  },

  -- GO
  "olexsmir/gopher.nvim",
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
    },
    config = function()
      require("go").setup()
    end,
  },
}
