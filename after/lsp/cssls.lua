---@type vim.lsp.Config
local config = {
  init_options = { provideFormatter = false },
  settings = {
    css = {
      validate = true,
      lint = {
        argumentsInColorFunction = 'warning',
        duplicateProperties = 'warning',
        emptyRules = 'warning',
        fontFaceProperties = 'warning',
        hexColorLength = 'warning',
        ieHack = 'warning',
        importStatement = 'warning',
        propertyIgnoredDueToDisplay = 'warning',
        unknownAtRules = 'ignore',
        unknownAtRules = 'warning',
        vendorPrefix = 'ignore', -- needed for scrollbars
        zeroUnits = 'warning',
      },
    },
    scss = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
    },
    less = {
      validate = true,
      lint = { unknownAtRules = 'ignore' },
    },
  },
}

return config
