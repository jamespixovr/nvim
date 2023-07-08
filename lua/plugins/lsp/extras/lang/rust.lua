return {

  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "Saecki/crates.nvim",
        event = { "BufRead Cargo.toml" },
        config = true,
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end
  },


  -- Rust Crates 🚀
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },

  --TODO: check this out
  -- rust
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = { "simrat39/rust-tools.nvim" },
  --   opts = {
  --     -- make sure mason installs the server
  --     servers = {
  --       rust_analyzer = {
  --         on_attach = function(_, bufnr)
  --           -- stylua: ignore
  --           vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<cr>", { desc = "Organize Imports", buffer = bufnr })
  --           -- stylua: ignore
  --           vim.keymap.set("n", "<leader>cu", "<cmd>TypescriptRemoveUnused<cr>", { desc = "Remove Unused", buffer = bufnr })
  --           -- stylua: ignore
  --           vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<cr>", { desc = "Rename File", buffer = bufnr })
  --         end,
  --       },
  --     },
  --     setup = {
  --       rust_analyzer = function(_, config)
  --         require("rust-tools").setup({ server = config })
  --         return true
  --       end,
  --     },
  --   },
  -- },


  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "mfussenegger/nvim-dap",
      "rust-lang/rust.vim"
    },
    opts = {
      -- make sure mason installs the server
      setup = {
        rust_analyzer = function(_, opts)
          require("helper").on_lsp_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "rust_analyzer" then
              vim.keymap.set("n", "K", "<CMD>RustHoverActions<CR>", { buffer = buffer })
              vim.keymap.set("n", "<leader>ct", "<CMD>RustDebuggables<CR>", { buffer = buffer, desc = "Run Test" })
              vim.keymap.set("n", "<leader>dr", "<CMD>RustDebuggables<CR>", { buffer = buffer, desc = "Run" })
            end
          end)
          local mason_registry = require("mason-registry")
          -- rust tools configuration for debugging support
          local codelldb = mason_registry.get_package("codelldb")
          local extension_path = codelldb:get_install_path() .. '/extension/'
          local codelldb_path = extension_path .. 'adapter/codelldb'
          local liblldb_path = vim.fn.has "mac" == 1 and extension_path .. 'lldb/lib/liblldb.dylib' or
              extension_path .. 'lldb/lib/liblldb.so'
          local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
            dap = {
              adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
            },
            tools = {
              hover_actions = {
                auto_focus = true,
              },
              inlay_hints = {
                auto = true,
                show_parameter_hints = true,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=>",
                only_current_line = false,
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
              },
            },
            server = {
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    features = "all",
                  },
                  -- Add clippy lints for Rust.
                  checkOnSave = true,
                  check = {
                    command = "clippy",
                    features = "all",
                  },
                  procMacro = {
                    enable = true,
                  },
                }
              }
            }
          })
          require("rust-tools").setup(rust_tools_opts)
          return true
        end,
        taplo = function(_, opts)
          local function show_documentation()
            if vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
              require('crates').show_popup()
            else
              vim.lsp.buf.hover()
            end
          end

          require("helper").on_lsp_attach(function(client, buffer)
            -- stylua: ignore
            if client.name == "taplo" then
              vim.keymap.set("n", "K", show_documentation, { buffer = buffer })
            end
          end)
          return false -- make sure the base implementation calls taplo.setup
        end,
      },
    },
  },
}
