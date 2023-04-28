return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "b0o/SchemaStore.nvim",
      version = false, -- last release is way too old
    },
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  }
}
