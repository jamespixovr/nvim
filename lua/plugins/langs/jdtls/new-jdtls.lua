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
          java = {
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
