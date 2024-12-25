return {
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    dependencies = {
      'rafamadriz/friendly-snippets',
      {
        'saghen/blink.compat',
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = '*',
      },
    },
    event = { 'InsertEnter *', 'CmdlineEnter *' },
    version = '*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- keymap = { preset = 'default' }, --default, super-tab or enter
      keymap = {
        preset = 'enter',
        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        cmdline = {
          preset = 'super-tab',
          ['<Tab>'] = { 'select_prev', 'fallback' },
          ['<S-Tab>'] = { 'select_next', 'fallback' },
        },
      },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'mono' },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = {
          border = vim.g.borderStyle,
          draw = {
            columns = { { 'kind_icon', gap = 2 }, { 'label', 'label_description', gap = 2 }, { 'kind', gap = 2 } },
            treesitter = { 'lsp' },
            components = {
              kind_icon = {
                ellipsis = true,
                text = function(ctx)
                  local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = vim.g.borderStyle },
        },
        ghost_text = { enabled = true },
      },
      signature = { window = { border = vim.g.borderStyle } },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion', 'lazydev', 'dadbod' },
        per_filetype = { codecompanion = { 'codecompanion' } },
        providers = {
          codecompanion = {
            name = 'CodeCompanion',
            module = 'codecompanion.providers.completion.blink',
            enabled = true,
          },
          lazydev = {
            name = '[lazy]',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- show at a higher priority than lsp
          },
          markdown = { name = '[md]', module = 'render-markdown.integ.blink' },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
      },
    },
    opts_extend = {
      'sources.default',
      'sources.completion.enabled_providers',
      'sources.compat',
    },
  },
  -- lazydev
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { 'lazydev' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
}
