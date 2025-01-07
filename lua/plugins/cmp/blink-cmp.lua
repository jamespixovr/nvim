local icons = require('lib.icons')

return {
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    version = '*',
    lazy = false, -- lazy loading handled internally
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    event = { 'InsertEnter' },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        ['<C-e>'] = { 'hide', 'fallback' },
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-k>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-j>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        cmdline = {
          preset = 'super-tab',
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
        },
      },
      appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'normal', kind_icons = icons.kind },
      enabled = function()
        return not vim.tbl_contains({}, vim.bo.filetype)
          -- and vim.bo.buftype ~= 'nofile'
          and vim.bo.buftype ~= 'prompt'
          and vim.b.completion ~= false
      end,
      completion = {
        list = { selection = 'manual' },
        accept = { auto_brackets = { enabled = false } },
        menu = {
          border = vim.g.borderStyle,
          draw = {
            columns = { { 'kind_icon', gap = 1 }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
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
        default = { 'lsp', 'buffer', 'path', 'snippets', 'codecompanion', 'lazydev', 'dadbod' },
        per_filetype = { codecompanion = { 'codecompanion' } },
        providers = {
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
    },
  },
}
