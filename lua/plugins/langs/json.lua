local filetypes = { 'json', 'jsonc', 'json5' }

return {
  --  DOCS https://github.com/Microsoft/vscode/tree/main/extensions/json-language-features/server#configuration
  {
    'neovim/nvim-lspconfig',
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
