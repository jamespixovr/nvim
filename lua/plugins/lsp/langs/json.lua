local filetypes = { 'json', 'jsonc', 'json5' }

return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'biome' })
        end,
      },
    },
    ft = filetypes,
    opts = {
      formatters_by_ft = {
        json = { 'biome' },
        jsonc = { 'biome' },
        json5 = { 'biome' },
      },
      formatters = {
        biome = {
          -- https://biomejs.dev/formatter/
          args = { 'format', '--indent-style', 'space', '--stdin-file-path', '$FILENAME' },
        },
      },
    },
  },
  --  DOCS https://github.com/Microsoft/vscode/tree/main/extensions/json-language-features/server#configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'b0o/SchemaStore.nvim',
    },
    ft = filetypes,
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          init_options = {
            provideFormatter = false,
            documentRangeFormattingProvider = false,
          },
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
          end,
          settings = {
            json = {
              -- schemas = require("schemastore").json.schemas(),
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
}
