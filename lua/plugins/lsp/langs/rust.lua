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
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5", -- Recommended
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>ca", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },

  -- Correctly setup lspconfig for Rust 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
  {
    "Saecki/crates.nvim",
    -- stylua: ignore
    keys = {
       { "<leader>prR", function() require("crates").reload() end, desc = "Reload" },

       { "<leader>pru", function() require("crates").update_crate() end, desc = "Update Crate" },
       { "<leader>pru", mode = "v", function() require("crates").update_crates() end, desc = "Update Crates" },
       { "<leader>pra", function() require("crates").update_all_crates() end, desc = "Update All Crates" },

       { "<leader>prU", function() require("crates").upgrade_crate() end, desc = "Upgrade Crate" },
       { "<leader>prU", mode = "v", function() require("crates").upgrade_crates() end, desc = "Upgrade Crates" },
       { "<leader>prA", function() require("crates").upgrade_all_crates() end, desc = "Upgrade All Crates" },

       { "<leader>prt", function() require("crates").expand_plain_crate_to_inline_table() end, desc = "Extract into Inline Table" },
       { "<leader>prT", function() require("crates").extract_crate_into_table() end, desc = "Extract into Table" },

       { "<leader>prh", function() require("crates").open_homepage() end, desc = "Homepage" },
       { "<leader>prr", function() require("crates").open_repository() end, desc = "Repo" },
       { "<leader>prd", function() require("crates").open_documentation() end, desc = "Documentation" },
       { "<leader>prc", function() require("crates").open_crates_io() end, desc = "Crates.io" },
    },
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>p", group = "packages/dependencies", icon = " " },
        { "<leader>pr", group = "rust", icon = " " },
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
}
