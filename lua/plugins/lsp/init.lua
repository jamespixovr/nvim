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
        "yaml-language-server",
        "taplo",
        "codelldb",
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
      "williamboman/mason.nvim",
      "b0o/SchemaStore.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "simrat39/symbols-outline.nvim",
        keys = {
          { "<leader>ss", "<cmd>SymbolsOutline<cr>", desc = "SymbolsOutline" },
        },
        config = true,
      },
    },
    ---@class PluginLspOpts
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
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
        docker_compose_language_service = {},
        dockerls = {},
        pyright = require("plugins.lsp.pyright"),
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
      keymaps.always_attach()
      helper.on_lsp_attach(function(client, buffer)
        format.on_attach(client, buffer)
      end)


      -- diagnostics
      for name, icon in pairs(settings.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
            or function(diagnostic)
              local icons = settings.icons.diagnostics
              for d, icon in pairs(icons) do
                if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                  return icon
                end
              end
            end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- lspconfig
      require('lspconfig.ui.windows').default_options.border = 'rounded'
      if vim.g.lsp_handlers_enabled then
        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
          { border = "rounded", silent = true })
        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded", silent = true })
      end
      local servers = opts.servers

      -- local capabilities = format.common_capabilities()
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities(),
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
      end
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

      return {
        debounce = 150,
        save_after_format = true,
        border = "rounded",
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          --  ╭────────────╮
          --  │ Formatting │
          --  ╰────────────╯
          fmt.prettier.with({
            dynamic_command = command_resolver.from_node_modules(),
          }),
          fmt.shfmt,
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
          dgn.tidy,                                           -- xml
          dgn.sqlfluff.with({
            extra_args = { "--dialect", "postgres" },
          }),
          dgn.buf.with({
            -- PROTO
            condition = function()
              return util.executable("buf", true)
            end,
          }),
          -- dgn.golangci_lint.with({
          --   condition = function()
          --     return util.executable("golangci-lint", true)
          --         and not vim.tbl_isempty(vim.fs.find("go.mod", {
          --           path = vim.fn.expand("%:p"),
          --           upward = true,
          --         }))
          --   end,
          -- }),
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
              return util.executable("shellcheck", false)
            end,
          }),

          --  ╭──────────────╮
          --  │ Code Actions │
          --  ╰──────────────╯
          -- cda.eslint_d.with({
          --   condition = function()
          --     return util.executable("eslint_d", true)
          --   end,
          -- }),
          cda.refactoring,
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
    keys = {
      { "gM", "<cmd>Glance implementations<cr>",  desc = "Goto Implementations (Glance)" },
      { "gY", "<cmd>Glance type_definitions<cr>", desc = "Goto Type Definition (Glance)" },
    },
    opts = {
      border = {
        enable = true,
      }
    }
  },
  -- language specific extension modules
  { import = "plugins.lsp.extras.lang.go" },
  { import = "plugins.lsp.extras.lang.json" },
  { import = "plugins.lsp.extras.lang.yaml" },
  { import = "plugins.lsp.extras.lang.typescript" },
  { import = "plugins.lsp.extras.lang.nodejs" },
  { import = "plugins.lsp.extras.lang.eslint" },
  { import = "plugins.lsp.extras.lang.rust" },
  -- { import = "plugins.lsp.extras.lang.cucumber" },
}
