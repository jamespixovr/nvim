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

      require('plugins.coding.lsp.keymaps')

      vim.lsp.config('copilot', {
        settings = {
          telemetry = {
            -- doesn't work, seems to be a vscode setting
            telemetryLevel = 'off',
          },
        },
      })

      require('plugins.coding.lsp.diagnostics')

      vim.api.nvim_create_user_command('LspLog', function()
        vim.cmd('edit ' .. vim.lsp.log.get_filename())
      end, {})

      -- disable lsp for .env files
      local group = vim.api.nvim_create_augroup('__env', { clear = true })
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = { '*.env', '.env*' },
        group = group,
        callback = function(args)
          vim.cmd([[set filetype=sh]]) -- set ft to sh to enable syntax highlighting
          vim.diagnostic.enable(false, { bufnr = args.buf })
        end,
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp_attach_server_caps', { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end
          if client.name == 'ruff' then
            -- Disable hover in favor of Pyright
            client.server_capabilities.hoverProvider = false
          end

          -- if client.name == 'yamlls' then
          --   -- Need this so that conform uses LSP to format yaml.* files.
          --   client.server_capabilities.documentFormattingProvider = true
          -- end

          if client.name == 'vue_ls' then
            -- Disable rename in hybrid mode (vtsls handles it)
            client.server_capabilities.renameProvider = false
          end

          -- Prevent LSP from attaching to virtual buffers such as diffview.
          -- local bufname = vim.api.nvim_buf_get_name(args.buf)
          -- if bufname:match('^diffview://') then
          --   vim.schedule(function()
          --     vim.lsp.buf_detach_client(args.buf, args.data.client_id)
          --   end)
          -- end
        end,
      })
    end,
  },
}
