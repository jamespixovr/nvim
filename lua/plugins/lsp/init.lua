return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- "BufReadPre",
    dependencies = {
      { "folke/neodev.nvim", config = true },
      "williamboman/mason.nvim",
      "b0o/SchemaStore.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      -- For Typescript
      {
        "pmizio/typescript-tools.nvim",
        opts = {
          settings = {
            tsserver_file_preferences = {
              includeInlayParameterNameHints = "all",
              includeCompletionsForModuleExports = true,
              quotePreference = "auto",
            },
          },
        },
      },
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

      -- but can be also overriden when specified
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
  }
}
