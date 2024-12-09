local util = require('lspconfig.util')
return {
  -- correctly setup mason lsp / dap extensions
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'delve',
        'gopls',
        'goimports',
        'golangci-lint',
        'golangci-lint-langserver', -- Wraps golangci-lint as a language server
      })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        golangci_lint_ls = {
          cmd = { 'golangci-lint-langserver' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
        }, -- linter
        gopls = {
          cmd = { 'gopls' },
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          root_dir = util.root_pattern('go.work', 'go.mod', '.git'),
          keys = {
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            -- { "<leader>td", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
          settings = {
            -- main readme: https://github.com/golang/tools/blob/master/gopls/doc/features/README.md
            --
            -- for all options, see:
            -- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
            -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            -- for more details, also see:
            -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
            -- https://github.com/golang/tools/blob/master/gopls/README.md
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = true, -- Show a code lens toggling the display of gc's choices.
                generate = true, -- show the `go generate` lens.
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = { -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = false,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                shadow = true,
                unusedvariable = true,
                fillreturns = true,
                nonewvars = true,
                undeclaredname = true,
                unreachable = true,
              },
              staticcheck = true,
              usePlaceholders = true,
              completeUnimported = true,
              directoryFilters = { '-**/node_modules', '-**/.git', '-.vscode', '-.idea', '-.vscode-test' },
              semanticTokens = true,
              symbolMatcher = 'fuzzy',
              buildFlags = { '-tags', 'integration' },
              diagnosticsDelay = '500ms',
              matcher = 'Fuzzy',
            },
          },
        },
      },
    },
  },
  {
    'jack-rabe/impl.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      layout_strategy = 'vertical',
      layout_config = {
        width = 0.5,
      },
    },
  },

  {
    'maxandron/goplements.nvim',
    ft = 'go',
    opts = {},
  },

  {
    'ray-x/go.nvim',
    lazy = true,
    dependencies = { -- optional packages
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup({
        lsp_inlay_hints = {
          enable = false,
        },
        dap_debug = false,
        dap_debug_gui = false,
        run_in_floaterm = true,
        luasnip = true,
        dap_debug_keymap = false,
        lsp_codelens = false,
        lsp_keymaps = false,
        diagnostic = false,
        test_runner = 'ginkgo',
        lsp_document_formatting = false,
      })
    end,
    event = { 'CmdlineEnter' },
    keys = {
      { '<leader>tgn', '<cmd>GinkgoFunc<CR>', desc = 'Run nearest test' },
      { '<leader>tgr', '<cmd>GoRun<CR>', desc = 'Run Go main' },
      { '<leader>tgf', '<cmd>GoTestFile<CR>', desc = 'Run test file' },
    },
    ft = { 'go', 'gomod' },
    -- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    'nvim-neotest/neotest',
    optional = true,
    dependencies = {
      -- { 'jarmex/neotest-ginkgo' },
      {
        'fredrikaverpil/neotest-golang',
        -- enabled = false,
        version = '*',
        dependencies = {
          'leoluz/nvim-dap-go',
        },
      },
    },
    opts = {
      adapters = {
        -- ['neotest-ginkgo'] = {
        --   -- Here we can set options for neotest-go, e.g.
        --   -- args = { "-tags=integration" }
        --   --   args = { "-count=1", "-timeout=60s", "-race", "-cover" },
        --   experimental = {
        --     test_table = true,
        --   },
        -- },
        -- ['neotest-golang'] = {
        --   args = { "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out" },
        --   experimental = {
        --     test_table = true,
        --   },
        -- },
      },
    },
  },
}
