return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        -- cssmodules_ls = {},
        -- css_variables = {},
        cssls = {
          -- using `biome` instead (this key overrides `settings.format.enable = true`)
          init_options = { provideFormatter = false },

          settings = {
            css = {
              lint = {
                vendorPrefix = 'ignore', -- needed for scrollbars
                duplicateProperties = 'warning',
                zeroUnits = 'warning',
                emptyRules = 'warning',
                importStatement = 'warning',
                fontFaceProperties = 'warning',
                hexColorLength = 'warning',
                argumentsInColorFunction = 'warning',
                unknownAtRules = 'warning',
                ieHack = 'warning',
                propertyIgnoredDueToDisplay = 'warning',
              },
            },
          },
        },
      },
    },
  },
}
