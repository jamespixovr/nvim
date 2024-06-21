return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" }, -- "BufReadPre",
    dependencies = {
      "williamboman/mason.nvim",
      "b0o/SchemaStore.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
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
        "<C-k>",
        function()
          require("lsp_signature").toggle_float_win()
        end,
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
}
