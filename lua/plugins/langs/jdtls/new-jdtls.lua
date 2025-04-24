-- https://github.com/lazymaniac/nvim-ide/blob/master/lua/plugins/lsp/lang/java.lua
return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
      local project_hash = string.sub(vim.api.nvim_call_function('sha256', { vim.fn.getcwd() }), 1, 6)
      local data_path = vim.env.HOME .. '/.cache/jdtls/' .. project_name .. '-' .. project_hash

      local on_attach = function(_, bufnr)
        require('jdtls.setup').add_commands()
        require('jdtls').setup_dap()
        require('plugins.lsp.lspconfig.keymaps').keymap(bufnr)
      end

      local config = {
        on_attach = on_attach,
        cmd = {
          'jdtls',
          '-configuration',
          vim.env.HOME .. '/.cache/jdtls/configuration',
          '-data',
          data_path,
        },
        cmd_env = {
          JAVA_HOME = require('lib.jvm').home(21),
        },
        init_options = {
          bundles = vim.split(vim.fn.glob(vim.env.MASON .. '/share/java-*/*.jar'), '\n'),
          extendedClientCapabilities = {
            progressReportProvider = false,
          },
        },
        settings = {
          redhat = {
            telemetry = {
              enabled = false,
            },
          },
          java = {
            import = {
              saveActions = {
                organizeImports = true,
              },
              maven = {
                enabled = true,
              },
              gradle = {
                enabled = true,
              },
            },
            implementationsCodeLens = {
              enabled = true,
            },
            referencesCodeLens = {
              enabled = true,
            },
            signatureHelp = {
              enabled = true,
            },
            configuration = {
              runtimes = {
                {
                  name = 'JavaSE-11',
                  path = require('lib.jvm').home(11),
                },
                {
                  name = 'JavaSE-17',
                  path = require('lib.jvm').home(17),
                },
                {
                  name = 'JavaSE-21',
                  path = require('lib.jvm').home(21),
                },
                {
                  name = 'JavaSE-23',
                  path = require('lib.jvm').home(23),
                },
              },
            },
            completion = {
              importOrder = { '', 'javax', 'java', '#' },
              matchCase = 'firstLetter',
              maxResults = 100,
              postfix = {
                enabled = true,
              },
              enabled = true,
              chain = {
                enabled = true,
              },
              collapseCompletionItems = true,
              lazyResolveTextEdit = {
                enabled = true,
              },
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
                'org.mockito.BDDMockito.*',
                'org.instancio.Instancio.*',
                'org.instancio.Select.*',
              },
              filteredTypes = { 'java.awt.*', 'com.sun.*', 'sun.*', 'jdk.*', 'org.graalvm.*', 'io.micrometer.shaded.*' },
              guessMethodArguments = 'auto',
            },
            cleanup = {
              actions = { 'renameFileToType' },
              actionsOnSave = {
                -- "qualifyMembers",
                -- "qualifyStaticMembers",
                'addOverride',
                'addDeprecated',
                'stringConcatToTextBlock',
                'invertEquals',
                -- "addFinalModifier",
                'instanceofPatternMatch',
                'lambdaExpression',
                'switchExpression',
              },
            },
            codeGeneration = {
              insertionLocation = 'afterCursor',
              generateComments = false,
              hashCodeEquals = {
                useInstanceof = true,
                useJava7Objects = true,
              },
              toString = {
                codeStyle = 'STRING_BUILDER_CHAINED', -- "STRING_CONCATENATION" | "STRING_BUILDER" | "STRING_BUILDER_CHAINED" | "STRING_FORMAT"
                limitElements = 0,
                listArrayContents = true,
                skipNullValues = false,
                template = '${object.className} [${member.name()}=${member.value}, ${otherMembers}]',
              },
              useBlocks = true,
            },
            codeAction = {
              sortMembers = {
                avoidVolatileChanges = false,
              },
            },
            refactoring = {
              extract = {
                interface = {
                  replace = true,
                },
              },
            },
            format = {
              comments = {
                enabled = true,
              },
              enabled = true,
              onType = {
                enabled = true,
              },
              settings = {
                url = '~/.config/nvim/java-formatter.xml',
              },
            },
            inlayHints = {
              parameterNames = {
                enabled = 'all', -- literals, all, none
                exclusions = {},
              },
            },
            maven = {
              downloadSources = true,
              updateSnapshots = false,
            },
            maxConcurrentBuilds = 1,
            references = {
              includeAccessors = true,
              includeDecompiledSources = true,
            },
          },
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'java',
        callback = function()
          require('jdtls').start_or_attach(config)
        end,
      })
    end,
  },
}
