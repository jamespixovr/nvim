return {
  -- add typescript to treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      if type(opts.ensure_installed) == 'table' then
        vim.list_extend(opts.ensure_installed, { 'typescript', 'tsx' })
      end
    end,
  },
  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of typescript-tools below.
  {
    'neovim/nvim-lspconfig',
    opts = {
      -- make sure mason installs the server
      servers = {
        ts_ls = {},
      },
      setup = {
        ts_ls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    'pmizio/typescript-tools.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      { 'dmmulroy/ts-error-translator.nvim', config = true },
    },
    ft = { 'javascriptreact', 'typescriptreact', 'javascript.jsx', 'typescript.tsx', 'javascript', 'typescript' },
    config = function()
      -- local api = require("typescript-tools.api")
      require('typescript-tools').setup({
        handlers = {
          ['textDocument/publishDiagnostics'] = function(err, result, ctx, config)
            require('ts-error-translator').translate_diagnostics(err, result, ctx, config)
            -- api.filter_diagnostics({ 80006, 80001 })(err, result, ctx, config)
            vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
          end,
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          expose_as_code_action = 'all',
          code_lens = 'off', -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          jsx_close_tag = {
            enable = true,
            filetypes = { 'javascriptreact', 'typescriptreact' },
          },
          tsserver_file_preferences = {
            includeInlayEnumMemberValueHints = false,
            includeInlayFunctionLikeReturnTypeHints = false,
            includeInlayFunctionParameterTypeHints = false,
            includeInlayParameterNameHints = 'all', -- none | literals | all
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = false,
            includeInlayVariableTypeHints = false,
            includeInlayVariableTypeHintsWhenTypeMatchesName = false,
            includeCompletionsForModuleExports = true,
          },
          tsserver_plugins = {
            -- https://github.com/styled-components/typescript-styled-plugin
            -- for TypeScript v4.9+
            '@styled/typescript-styled-plugin',
            -- or for older TypeScript versions
            -- "typescript-styled-plugin",
          },
          separate_diagnostic_server = true,
        },
      })
    end,
  },

  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      { 'haydenmeade/neotest-jest', version = false },
    },
    opts = {
      adapters = {
        ['neotest-jest'] = {
          jestCommand = 'pnpm jest',
          -- jestConfigFile = "jest.config.js",
          env = { CI = true },
          cwd = function(path)
            return require('lspconfig.util').root_pattern('package.json', 'jest.config.js')(path)
          end,
        },
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    opts = {
      setup = {
        vscode_js_debug = function()
          local function get_js_debug()
            local install_path = require('mason-registry').get_package('js-debug-adapter'):get_install_path()
            return install_path .. '/js-debug/src/dapDebugServer.js'
          end

          for _, adapter in ipairs({ 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }) do
            require('dap').adapters[adapter] = {
              type = 'server',
              host = 'localhost',
              port = '${port}',
              executable = {
                command = 'node',
                args = {
                  get_js_debug(),
                  '${port}',
                },
              },
            }
          end

          for _, language in ipairs({ 'typescript', 'javascript' }) do
            require('dap').configurations[language] = {
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Launch file',
                program = '${file}',
                cwd = '${workspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'attach',
                name = 'Attach',
                processId = require('dap.utils').pick_process,
                cwd = '${workspaceFolder}',
              },
              {
                type = 'pwa-node',
                request = 'launch',
                name = 'Debug Jest Tests',
                -- trace = true, -- include debugger info
                runtimeExecutable = 'node',
                runtimeArgs = {
                  './node_modules/jest/bin/jest.js',
                  '--runInBand',
                },
                rootPath = '${workspaceFolder}',
                cwd = '${workspaceFolder}',
                console = 'integratedTerminal',
                internalConsoleOptions = 'neverOpen',
              },
              {
                type = 'pwa-chrome',
                name = 'Attach - Remote Debugging',
                request = 'attach',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = '${workspaceFolder}',
              },
              {
                type = 'pwa-chrome',
                name = 'Launch Chrome',
                request = 'launch',
                url = 'http://localhost:5173', -- This is for Vite. Change it to the framework you use
                webRoot = '${workspaceFolder}',
                userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
              },
            }
          end

          for _, language in ipairs({ 'typescriptreact', 'javascriptreact' }) do
            require('dap').configurations[language] = {
              {
                type = 'pwa-chrome',
                name = 'Attach - Remote Debugging',
                request = 'attach',
                program = '${file}',
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = 'inspector',
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = '${workspaceFolder}',
              },
              {
                type = 'pwa-chrome',
                name = 'Launch Chrome',
                request = 'launch',
                url = 'http://localhost:5173', -- This is for Vite. Change it to the framework you use
                webRoot = '${workspaceFolder}',
                userDataDir = '${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir',
              },
            }
          end
        end,
      },
    },
  },
}
