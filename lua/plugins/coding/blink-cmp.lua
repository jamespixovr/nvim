local icons = require('helpers.icons')

-- Documentation site: https://cmp.saghen.dev/

return {
  {
    'saghen/blink.cmp',
    build = 'cargo +nightly build --release',
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      'folke/lazydev.nvim',
      'onsails/lspkind.nvim',
    },
    event = { 'BufReadPost', 'CmdlineEnter' },
    version = '*',
    lazy = false, -- lazy loading handled internally
    opts = {
      fuzzy = {
        frecency = {
          enabled = true,
        },
        implementation = 'rust',
      },
      cmdline = {
        enabled = true,
        sources = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          if type == ':' then
            return { 'cmdline' }
          end
          return {}
        end,
        keymap = {
          preset = 'super-tab',
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
        },
        completion = {
          ghost_text = { enabled = false },
          menu = {
            auto_show = true,
            draw = {
              columns = { { 'kind_icon', 'label', 'label_description' } },
            },
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
        },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          codecompanion = { 'codecompanion', 'buffer' },
          -- sql = { 'dadbod' },
          -- optionally inherit from the `default` sources
          lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
          -- lsp = {
          -- min_keyword_length = 2, -- Number of characters to trigger provider
          -- score_offset = 0, -- Boost/penalize the score of the items
          -- },
          path = {
            enabled = function()
              return vim.bo.filetype ~= 'codecompanion'
            end,
            min_keyword_length = 0,
            opts = {
              trailing_slash = false,
              label_trailing_slash = true,
              get_cwd = function(context)
                return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
              end,
              show_hidden_files_by_default = true,
            },
          },
          buffer = {
            min_keyword_length = 4,
            max_items = 5,
          },
          codecompanion = {
            name = 'codecompanion',
            module = 'codecompanion.providers.completion.blink',
          },
          snippets = {
            min_keyword_length = 2,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      snippets = { preset = 'luasnip' },
      keymap = {
        preset = 'enter',
        ['<C-p>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
      },

      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'normal', kind_icons = icons.kind },
      signature = { window = { border = vim.g.borderStyle } },
      enabled = function()
        if vim.bo.filetype == 'neovim-tips-search' then
          return false
        end

        local recording_macro = vim.fn.reg_recording() ~= '' or vim.fn.reg_executing() ~= ''
        return not vim.tbl_contains({}, vim.bo.filetype)
          and vim.bo.buftype ~= 'prompt'
          and vim.b.completion ~= false
          and not recording_macro
      end,
      completion = {
        list = { selection = { preselect = false, auto_insert = true } },
        menu = {
          border = vim.g.borderStyle,
          draw = {
            columns = { { 'kind_icon', 'label', gap = 1 }, { 'label_description', gap = 1 }, { 'kind' } },
            components = {
              kind_icon = {
                text = function(item)
                  local kind = require('lspkind').symbol_map[item.kind] or ''
                  return kind .. ' '
                end,
                -- highlight = 'CmpItemKind',
              },
              label = {
                text = function(item)
                  return item.label
                end,
                highlight = 'CmpItemAbbr',
              },
              kind = {
                text = function(item)
                  return item.kind
                end,
                -- highlight = 'CmpItemKind',
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = vim.g.borderStyle },
        },
        ghost_text = { enabled = false },
      },
    },
    opts_extend = {
      'sources.default',
    },
    config = function(_, opts)
      local blink_cmp = require('blink.cmp')
      blink_cmp.setup(opts)
      -- Extend neovim's client capabilities with the completion ones
      -- vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities(nil, true) })

      -- Ensure doc window is treated as markdown by treesitter
      vim.treesitter.language.register('markdown', 'blink-cmp-documentation')

      -- Autocmd settings
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LuasnipInsertNodeEnter',
        callback = function()
          vim.schedule(function()
            blink_cmp.show()
          end)
        end,
      })
    end,
  },
}
