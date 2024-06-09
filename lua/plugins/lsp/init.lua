return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "b0o/SchemaStore.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { 'antosha417/nvim-lsp-file-operations', config = true },
    },
    ---@class PluginLspOpts
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },

      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },

      ---@type lspconfig.options
      servers = {},
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
      require("plugins.lsp.lspconfig.setup").setup(opts)
    end,
  },
  { -- signature hints
    "ray-x/lsp_signature.nvim",
    event = "BufReadPre",
    keys = {
      {
        "<D-g>",
        function() require("lsp_signature").toggle_float_win() end,
        mode = { "n", "v", "i" },
        desc = "󰒕 LSP signature",
      },
    },
    opts = {
      hint_prefix = "󰏪 ",
      hint_scheme = "@variable.parameter", -- highlight group
      floating_window = false,
      always_trigger = true,
      handler_opts = { border = vim.g.borderStyle },
      auto_close_after = 3000,
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        "lazy.nvim",
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>fd",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        css = { { "prettied", "prettier" } },
        graphql = { { "prettied", "prettier" } },
        html = { { "prettied", "prettier" } },
        javascript = { { "prettied", "prettier" } },
        javascriptreact = { { "prettied", "prettier" } },
        json = { "jq" },
        -- json = { { "prettied", "prettier" } },
        lua = { "stylua" },
        go = { "goimports", "gofmt" },
        markdown = { { "prettied", "prettier" } },
        python = { "isort", "black" },
        sql = { "sql-formatter" },
        svelte = { { "prettied", "prettier" } },
        typescript = { { "prettied", "prettier" } },
        typescriptreact = { { "prettied", "prettier" } },
        yaml = { "prettier" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        typescript = { "biomejs", "eslint_d", "eslint" },
        javascript = { "biomejs", "eslint_d", "eslint" },
        typescriptreact = { "biomejs", "eslint_d", "eslint" },
        javascriptreact = { "biomejs", "eslint_d", "eslint" },
        svelte = { "eslint_d" },
        python = { "pylint" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
    config = function(_, opts)
      require("lint").linters_by_ft = opts.linters_by_ft
      require("lint").linters = opts.linters

      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  }
}
