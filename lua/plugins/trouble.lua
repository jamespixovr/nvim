return {
  -- better diagnostics list and others
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    cmd = 'Trouble',
    opts = {
      focus = true,
      max_items = 500, -- limit number of items that can be displayed per section
      warn_no_results = false, -- show a warning when there are no results
      open_no_results = true, -- open the trouble window when there are no results
      ---@type trouble.Window.opts
      preview = {
        type = 'main',
        scratch = false,
      },
      modes = {
        lsp = {
          win = { position = 'right' },
        },
        lsp_references = {
          desc = 'LSP References',
          mode = 'lsp_references',
          title = false,
          restore = true,
          focus = false,
          follow = false,
        },
        lsp_definitions = {
          desc = 'LSP definitions',
          mode = 'lsp_definitions',
          title = false,
          restore = true,
          focus = false,
          follow = false,
        },
        lsp_document_symbols = {
          title = false,
          focus = false,
          format = '{kind_icon}{symbol.name} {text:Comment} {pos}',
        },
        test = {
          mode = 'diagnostics',
          preview = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.3,
          },
        },
      },
    },
    specs = {
      'folke/snacks.nvim',
      opts = function(_, opts)
        return vim.tbl_deep_extend('force', opts or {}, {
          picker = {
            actions = require('trouble.sources.snacks').actions,
            win = {
              input = {
                keys = {
                  ['<c-t>'] = {
                    'trouble_open',
                    mode = { 'n', 'i' },
                  },
                },
              },
            },
          },
        })
      end,
    },
    keys = {
      { '<leader>xX', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
      {
        '<leader>xl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
    },
  },
}
