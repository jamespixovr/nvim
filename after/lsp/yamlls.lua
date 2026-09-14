---@type vim.lsp.Config
local config = {
  filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.github' },
  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      schemaStore = {
        -- Must disable built-in schemaStore support to use
        -- schemas from SchemaStore.nvim plugin
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
      filetype_exclude = { 'helm' },
    },
  },
}
return config
