local Util = require('helper')

return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'java' })
    end,
  },

  -- Ensure java debugger and test packages are installed.
  {
    'mfussenegger/nvim-dap',
    optional = true,
    opts = function()
      -- Simple configuration to attach to remote java debug process
      -- Taken directly from https://github.com/mfussenegger/nvim-dap/wiki/Java
      local dap = require('dap')
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Debug (Attach) - Remote',
          hostName = '127.0.0.1',
          port = 5005,
        },
      }
    end,
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'java-test', 'java-debug-adapter' })
        end,
      },
    },
  },

  -- Configure nvim-lspconfig to install the server automatically via mason, but
  -- defer actually starting it to our configuration of nvim-jtdls below.
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        jdtls = {},
      },
      setup = {
        jdtls = function()
          return true -- avoid duplicate servers
        end,
      },
    },
  },
  {
    'nvim-java/nvim-java',
    ft = 'java',
    cmd = {
      'JavaBuildBuildWorkspace',
      'JavaBuildCleanWorkspace',
      'JavaRunnerRunMain',
      'JavaRunnerStopMain',
      'JavaRunnerToggleLogs',
      'JavaDapConfig',
      'JavaTestRunCurrentClass',
      'JavaTestDebugCurrentClass',
      'JavaTestRunCurrentMethod',
      'JavaTestDebugCurrentMethod',
      'JavaTestViewLastReport',
      'JavaProfile',
      'JavaRefactorExtractVariable',
      'JavaRefactorExtractVariableAllOccurrence',
      'JavaRefactorExtractConstant',
      'JavaRefactorExtractMethod',
      'JavaRefactorExtractField',
      'JavaSettingsChangeRuntime',
    },
    config = function()
      require('java').setup({
        -- NOTE: One of these files must be in your project root directory.
        --       Otherwise the debugger will end in the wrong directory and fail.
        root_markers = {
          'settings.gradle',
          'settings.gradle.kts',
          'pom.xml',
          'build.gradle',
          'mvnw',
          'gradlew',
          'build.gradle',
          'build.gradle.kts',
          '.git',
        },
        spring_boot_tools = {
          enable = false,
        },
        notifications = {
          dap = false,
        },
        jdk = {
          auto_install = false,
        },
      })
      require('lspconfig').jdtls.setup({
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        flags = { allow_incremental_sync = true },
        -- on_attach = function(client, bufnr)
        --   set_keymap(client, bufnr)
        --   set_inlay_hint(client, bufnr)
        -- end,
        settings = {
          java = {
            autobuild = { enabled = false },
            maxConcurrentBuilds = 1,
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            saveActions = {
              organizeImports = true,
            },
            maven = {
              downloadSources = true,
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            references = {
              includeDecompiledSources = true,
            },
            format = {
              enabled = true,
              -- Formatting works by default, but you can refer to a specific file/URL if you choose
              -- settings = {
              --   url = "https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml",
              --   profile = "GoogleStyle",
              -- },
              --
              -- settings = {
              --   profile = 'nvim gestion',
              --   url = 'file:///Users/jamesamo/.config/nvim/.linter_configs/GoogleStyle.xml',
              -- },
            },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-11',
                  path = '/opt/homebrew/opt/openjdk@11',
                  default = true,
                },
                {
                  name = 'JavaSE-23',
                  path = '/opt/homebrew/opt/openjdk@23',
                },
              },
            },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
              importOrder = {
                'java',
                'javax',
                'com',
                'org',
              },
            },
          },
        },
      })
    end,
  },
}
