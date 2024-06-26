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
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },

      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- add any global capabilities here
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
  { -- display inlay hints from at EoL, not in the text
    "lvimuser/lsp-inlayhints.nvim",
    keys = {
      {
        "<leader>oh",
        function()
          require("lsp-inlayhints").toggle()
        end,
        desc = "󰒕 Inlay Hints",
      },
    },
    opts = {
      inlay_hints = {
        labels_separator = "",
        parameter_hints = {
          prefix = " 󰏪 ",
          remove_colon_start = true,
          remove_colon_end = true,
        },
        type_hints = {
          prefix = " 󰜁 ",
          remove_colon_start = true,
          remove_colon_end = true,
        },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end
          require("lsp-inlayhints").on_attach(client, args.buf)
        end,
      })
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
  { -- CodeLens, but also for languages not supporting it
    "Wansmer/symbol-usage.nvim",
    event = "LspAttach",
    opts = {
      request_pending_text = false, -- remove "loading…"
      references = { enabled = true, include_declaration = false },
      definition = { enabled = false },
      implementation = { enabled = false },
      vt_position = "signcolumn",
      vt_priority = 5, -- below the gitsigns default of 6
      hl = { link = "Comment" },
      text_format = function(symbol)
        if not symbol.references or symbol.references == 0 then
          return
        end
        if symbol.references < 2 and vim.bo.filetype == "css" then
          return
        end
        if symbol.references > 100 then
          return "++"
        end

        local refs = tostring(symbol.references)
        local altDigits = -- there is no numeric `0` nerdfont icon, so using dot
          { "", "󰬺", "󰬻", "󰬼", "󰬽", "󰬾", "󰬿", "󰭀", "󰭁", "󰭂" }
        for i = 0, #altDigits - 1 do
          refs = refs:gsub(tostring(i), altDigits[i + 1])
        end
        return refs
      end,
      -- available kinds: https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
      kinds = {
        vim.lsp.protocol.SymbolKind.Function,
        vim.lsp.protocol.SymbolKind.Method,
        vim.lsp.protocol.SymbolKind.Class,
        vim.lsp.protocol.SymbolKind.Interface,
        vim.lsp.protocol.SymbolKind.Constructor,
      },
    },
  },
}
