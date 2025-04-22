return {
  {
    'hoffs/omnisharp-extended-lsp.nvim',
    lazy = true,
    ft = { 'cs', 'vb' },
    keys = {
      {
        'gd',
        function()
          require('omnisharp_extended').telescope_lsp_definition()
        end,
        { noremap = true },
        desc = 'Go to definition',
        ft = { 'cs', 'vb' },
      },
      {
        'gD',
        "<cmd>lua require('omnisharp_extended').lsp_type_definition()<cr>",
        desc = 'Go to type definition',
        ft = { 'cs', 'vb' },
      },
      {
        'gr',
        function()
          require('omnisharp_extended').telescope_lsp_references(
            require('telescope.themes').get_ivy({ excludeDefinition = true })
          )
        end,
        desc = 'Go to references',
        ft = { 'cs', 'vb' },
      },
      {
        'gi',
        "<cmd>lua require('omnisharp_extended').lsp_implementation()<cr>",
        desc = 'Go to implementation',
        ft = { 'cs', 'vb' },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        omnisharp = {
          handlers = {
            ['textDocument/definition'] = function(...)
              return require('omnisharp_extended').handler(...)
            end,
          },
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
              OrganizeImports = true,
            },
            Sdk = {
              IncludePrereleases = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
              EnableImportCompletion = true,
              InlayHintsOptions = {
                EnableForParameters = true,
                ForLiteralParameters = true,
                ForIndexerParameters = true,
                ForObjectCreationParameters = true,
                ForOtherParameters = true,
                SuppressForParametersThatDifferOnlyBySuffix = false,
                SuppressForParametersThatMatchMethodIntent = false,
                SuppressForParametersThatMatchArgumentName = false,
                EnableForTypes = true,
                ForImplicitVariableTypes = true,
                ForLambdaParameterTypes = true,
                ForImplicitObjectCreatio = true,
              },
            },
          },
          enable_roslyn_analyzers = true,
          organize_imports_on_format = true,
          enable_import_completion = true,
        },
      },
    },
  },
}
