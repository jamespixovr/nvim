return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        yamlls = {
          hover = true,
          completion = true,
          validate = true,
          settings = {
            yaml = {
              hover = true,
              completion = true,
              validate = true,
              -- other settings. note this overrides the lspconfig defaults.
              schemas = require('schemastore').yaml.schemas(),
            },
          },
        },
      },
    },
  }
}
