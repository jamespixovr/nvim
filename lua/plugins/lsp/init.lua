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
      library = {
        library = { plugins = { "nvim-dap-ui" }, types = true },
      }
    },
  },
  -- tools
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>mc", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      },
      ensure_installed = {
        "rust_analyzer",
        "lua-language-server",
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
      {
        "simrat39/symbols-outline.nvim",
        keys = {
          { "<leader>ss", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
        },
        config = true,
      },
      {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
          local lsp_lines = require("lsp_lines")
          lsp_lines.setup()
          lsp_lines.toggle()
          vim.keymap.set("n", "<leader><leader>od", function()
            local virt_lines = lsp_lines.toggle()
            vim.diagnostic.config({ virtual_text = not virt_lines })
          end)
        end,
      },
    },
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
        bashls = { filetypes = { "sh", "zsh" } },
        clangd = {},
        cssls = {},
        html = {},
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

      -- local capabilities = format.common_capabilities()
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = vim.tbl_deep_extend("force", capabilities, opts.capabilities)


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
          server_opts = vim.tbl_deep_extend("force", {}, common_options, server_opts or {})
          if opts.setup[server] then
            if opts.setup[server](server, server_opts) then
              return
            end
          end

          require("lspconfig")[server].setup(server_opts)
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

  -- formatters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "jayp0521/mason-null-ls.nvim" },
    build = {
      "go install github.com/daixiang0/gci@latest",
      "go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
      "go install golang.org/x/tools/cmd/goimports@latest"
    },
    opts = function()
      require("mason-null-ls").setup({
        -- list of formatters & linters for mason to install
        ensure_installed = { "stylua", "prettierd", "gofmt", "goimports", "golangci_lint" },
        -- auto-install configured servers (with lspconfig)
        automatic_installation = true
      })
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
          -- fmt.eslint_d.with({
          --   condition = function()
          --     return util.executable("eslint_d", true)
          --   end,
          -- }),
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
          -- dgn.staticcheck,   --GO
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
          -- require("typescript.extensions.null-ls.code-actions"),
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
  -- language specific extension modules
  { import = "plugins.lsp.extras.lang.go" },
  { import = "plugins.lsp.extras.lang.json" },
  { import = "plugins.lsp.extras.lang.typescript" },
  { import = "plugins.lsp.extras.lang.nodejs" },
  { import = "plugins.lsp.extras.lang.rust" },
}
