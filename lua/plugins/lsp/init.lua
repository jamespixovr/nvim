local helper = require("helper")
local settings = require("settings")
local format = require("plugins.lsp.format")
local keymaps = require("plugins.lsp.keymaps")

return {

  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = {
        pathStrict = true,
      },
    },
  },
  -- tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "rust_analyzer",
        "lua_ls",
        "tsserver",
        "gopls",
        "yamlls",
        "jsonls",
        "emmet_ls",
        "prettierd",
        "stylua",
        "eslint_d",
        "shellcheck",
        "luacheck",
        "shfmt",
      },
    },
  },
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim",  config = true },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    init = function()

    end,
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = {
          focusable = true,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      capabilities = {},
      servers = {
        rust_analyzer = require("plugins.lsp.rusttools"),
        bashls = {},
        clangd = {},
        cssls = {},
        html = {},
        gopls = require("plugins.lsp.gopls"),
        pyright = require("plugins.lsp.pyright"),
        yamlls = require("plugins.lsp.yamlls"),
        lua_ls = require("plugins.lsp.luals"),
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts: table):boolean?>
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      format.autoformat = opts.autoformat
      -- setup formatting and keymaps
      helper.on_lsp_attach(function(client, buffer)
        -- format.on_attach(client, buffer)
        keymaps.on_attach(client, buffer)
      end)


      -- diagnostics
      for name, icon in pairs(settings.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
      -- lspconfig
      local servers = opts.servers

      local capabilities = format.common_capabilities()
      -- require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities = vim.tbl_deep_extend("force", opts.capabilities, capabilities)


      local common_options = {
        on_attach = format.on_attach,
        capabilities = capabilities,
      }
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
      require("mason-lspconfig").setup_handlers({
        function(server)
          local server_opts = servers[server] or {}
          if server == "rust_analyzer" then
            -- rust-tools is special, and expects lsp server related configuration in the "server" key (everything else just uses the top level table)
            server_opts.server = vim.tbl_deep_extend("force", {}, common_options, server_opts.server or {})
            require("rust-tools").setup(server_opts)
          else
            server_opts = vim.tbl_deep_extend("force", {}, common_options, server_opts or {})
            if opts.setup[server] then
              if opts.setup[server](server, server_opts) then
                return
              end
            end

            require("lspconfig")[server].setup(server_opts)
          end
        end,
      })
    end,
  },

  -- Rust Crates 🚀
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  --closes some gaps that exist between mason.nvim and null-ls
  {
    "jayp0521/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("mason-null-ls").setup({
        automatic_installation = true,
      })
    end,
  },

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local util = require("helper")
      local nls = require("null-ls")
      local fmt = nls.builtins.formatting
      local dgn = nls.builtins.diagnostics
      local cda = nls.builtins.code_actions
      local command_resolver = require("null-ls.helpers.command_resolver")

      local function preferedEslint(utils)
        return utils.root_has_file({
          ".eslintrc",
          ".eslintrc.yml",
          ".eslintrc.yaml",
          ".eslintrc.js",
          "eslintrc.json",
        })
      end

      return {
        debounce = 150,
        save_after_format = true,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
        sources = {
          --  ╭────────────╮
          --  │ Formatting │
          --  ╰────────────╯
          fmt.prettier.with({
            dynamic_command = command_resolver.from_node_modules(),
          }),
          fmt.tidy,
          fmt.stylua.with({
            condition = function()
              return util.executable("stylua", true)
                  and not vim.tbl_isempty(vim.fs.find({ ".stylua.toml", "stylua.toml" }, {
                    path = vim.fn.expand("%:p"),
                    upward = true,
                  }))
            end,
          }),
          fmt.rustfmt, -- rust
          fmt.sqlfluff.with({
            extra_args = { "--dialect", "postgres" },
          }),
          fmt.buf, --PROTO
          -- fmt.goimports_reviser.with({
          --   condition = function()
          --     return util.executable("goimports-reviser", true)
          --         and not vim.tbl_isempty(vim.fs.find("go.mod", {
          --           path = vim.fn.expand("%:p"),
          --           upward = true,
          --         }))
          --   end,
          -- }),
          fmt.pg_format.with({
            condition = function()
              return util.executable("pg_format", true)
            end,
          }),
          fmt.eslint_d.with({
            condition = function()
              return util.executable("eslint_d", true)
            end,
          }),
          fmt.gofumpt,   -- GO
          fmt.goimports, --GO

          --  ╭─────────────╮
          --  │ Diagnostics │
          --  ╰─────────────╯
          dgn.yamllint.with({ extra_filetypes = { "yml" } }), -- add support for yml extensions
          dgn.eslint.with({
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return preferedEslint(utils)
            end,
          }),
          dgn.tidy, -- xml
          dgn.sqlfluff.with({
            extra_args = { "--dialect", "postgres" },
          }),
          dgn.buf.with({
            -- PROTO
            condition = function()
              return util.executable("buf", true)
            end,
          }),
          dgn.golangci_lint.with({
            condition = function()
              return util.executable("golangci-lint", true)
                  and not vim.tbl_isempty(vim.fs.find("go.mod", {
                    path = vim.fn.expand("%:p"),
                    upward = true,
                  }))
            end,
          }),
          dgn.hadolint,      -- dockerfile
          dgn.dotenv_linter, --ENV
          dgn.staticcheck,   --GO
          dgn.markdownlint.with({
            condition = function()
              return util.executable("markdownlint", true)
            end,
          }),
          dgn.shellcheck.with({
            condition = function()
              return util.executable("shellcheck", true)
            end,
          }),

          --  ╭──────────────╮
          --  │ Code Actions │
          --  ╰──────────────╯
          cda.eslint_d.with({
            condition = function()
              return util.executable("eslint_d", true)
            end,
          }),
          cda.refactoring,
          cda.eslint.with({
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return preferedEslint(utils)
            end,
          }),
          cda.shellcheck.with({
            condition = function()
              return util.executable("shellcheck", true)
            end,
          }),
          -- typescript nvim
          require("typescript.extensions.null-ls.code-actions"),
        },
      }
    end,
  },
  {
    "DNLHC/glance.nvim",
    event = "BufReadPre",
    config = true,
    keys = {
      { "gM", "<cmd>Glance implementations<cr>",  desc = "Goto Implementations (Glance)" },
      { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
    },
  },
}
