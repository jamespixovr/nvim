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
          -- Have to add this for yamlls to understand that we support line folding
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = {
                enable = true,
              },
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
