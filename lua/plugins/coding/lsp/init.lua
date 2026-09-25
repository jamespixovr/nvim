return {
  {
    'qvalentin/helm-ls.nvim',
    ft = 'helm',
    opts = {},
  },
  {
    'neovim/nvim-lspconfig',
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'mfussenegger/nvim-dap',
      { 'b0o/SchemaStore.nvim', lazy = true, version = false },
    },
    config = function()
      require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle
      require('plugins.coding.lsp.keymaps')
      require('plugins.coding.lsp.diagnostics')

      -- This should be executed before you configure any language server
      --
      local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
      lsp_capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
      -- Enable file watching for LSP
      -- It's disabled because the default implementation is considered slow.
      lsp_capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

      local has_blink, blink = pcall(require, 'blink.cmp')
      lsp_capabilities =
        vim.tbl_deep_extend('force', lsp_capabilities, has_blink and blink.get_lsp_capabilities() or {}, {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true,
            },
          },
        })

      vim.lsp.config('*', {
        capabilities = lsp_capabilities,
      })

      local packages = require('mason-registry').get_installed_packages()
      local names = vim.iter(packages):map(function(pack)
        return pack.spec.neovim and pack.spec.neovim.lspconfig
      end)

      vim.lsp.enable(names:totable())

      vim.lsp.config('html', {
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      })
      vim.lsp.enable('html', true)

      -- vim.lsp.enable('tsgo', true)

      -- Enable codelens globally
      vim.lsp.codelens.enable(true)

      vim.lsp.config('copilot', {
        settings = {
          telemetry = {
            -- doesn't work, seems to be a vscode setting
            telemetryLevel = 'off',
          },
        },
      })
    end,
  },
}
