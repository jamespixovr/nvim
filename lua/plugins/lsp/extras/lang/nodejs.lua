return {

  -- extend auto completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        "vuki656/package-info.nvim",
        event = { "BufRead package.json" },
        config = true,
      },
      {
        "David-Kunz/cmp-npm",
        event = { "BufRead package.json" },
        config = true,
      }
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "npm", keyword_length = 3 },
      }))
    end
  },

  -- correctly setup mason lsp / dap extensions
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "css-lsp", "eslint-lsp", "html-lsp", "js-debug-adapter", "stylelint-lsp" })
    end,
  },


  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = {
      {
        "microsoft/vscode-js-debug",
        build = {
          "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && rm -rf out && mv dist out"
        }
      },

    },
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      local dap_js = require("dap-vscode-js")
      -- local mason_registry = require("mason-registry")
      -- local js_debug_pkg = mason_registry.get_package("js-debug-adapter")
      -- local js_debug_path = js_debug_pkg:get_install_path()
      local DEBUGGER_PATH = vim.fn.stdpath("data") .. '/lazy/vscode-js-debug'
      dap_js.setup({
        debugger_path = DEBUGGER_PATH,
        adapters = { "pwa-node", "node-terminal" }, -- which adapters to register in nvim-dap
      })
      local exts = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' }
      for _, language in ipairs(exts) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (" .. language .. ")",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach (" .. language .. ")",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach Program (pwa-node)',
            cwd = vim.fn.getcwd(),
            processId = require('dap.utils').pick_process,
            skipFiles = { '<node_internals>/**' },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Test Current File (pwa-node with jest)',
            cwd = vim.fn.getcwd(),
            runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
            runtimeExecutable = 'node',
            args = { '${file}', '--coverage', 'false' },
            rootPath = '${workspaceFolder}',
            sourceMaps = true,
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
          }
        }
      end
      require("dap.ext.vscode").load_launchjs(nil, {
        ['node'] = {
          'javascript',
          'typescript',
        },
      })
    end
  },
}
