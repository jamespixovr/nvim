return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cssls = {
          -- using `biome` instead (this key overrides `settings.format.enable = true`)
          init_options = { provideFormatter = false },

          settings = {
            css = {
              lint = {
                vendorPrefix = "ignore", -- needed for scrollbars
                duplicateProperties = "warning",
                zeroUnits = "warning",
              },
            },
          },
        },
        css_variables = {
          root_dir = function()
            -- Add custom root markers for Obsidian snippet folders.
            local markers = { ".project-root", ".git" }
            return vim.fs.root(0, markers)
          end,
        },
      },
    },
  },
}
