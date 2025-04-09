return {
  {
    'hoffs/omnisharp-extended-lsp.nvim',
    lazy = true,
    ft = { 'cs', 'vb' },
    keys = {
      {
        'gd',
        "<cmd>lua require('omnisharp_extended').lsp_definition()<cr>",
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
        "<cmd>lua require('omnisharp_extended').lsp_references()<cr>",
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
            -- ['textDocument/definition'] = require('omnisharp_extended').definition_handler,
            -- ['textDocument/typeDefinition'] = require('omnisharp_extended').type_definition_handler,
            -- ['textDocument/references'] = require('omnisharp_extended').references_handler,
            -- ['textDocument/implementation'] = require('omnisharp_extended').implementation_handler,
          },
          settings = {
            RoslynExtensionsOptions = {
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
          keys = {
            {
              'gd',
              function()
                require('omnisharp_extended').lsp_definitions()
              end,
              desc = 'Goto Definition',
            },
            {
              'gr',
              function()
                require('omnisharp_extended').lsp_references()
              end,
              desc = 'Goto References',
            },
            {
              'gi',
              function()
                require('omnisharp_extended').lsp_implementation()
              end,
              desc = 'Goto Implementation',
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
