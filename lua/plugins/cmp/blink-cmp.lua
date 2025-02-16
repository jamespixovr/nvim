local icons = require('lib.icons')

-- Documentation site: https://cmp.saghen.dev/

return {
  {
    'saghen/blink.cmp',
    tag = 'v0.11.0',
    build = 'cargo +nightly build --release',
    dependencies = {
      { 'L3MON4D3/LuaSnip', version = 'v2.*' },
      { 'saghen/blink.compat', opts = {} },
    },
    event = { 'InsertEnter' },
    opts = {
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'codecompanion', 'dadbod' },
        providers = {
          lsp = {
            name = 'lsp',
            enabled = true,
            module = 'blink.cmp.sources.lsp',
            fallbacks = { 'snippets', 'buffer' },
            score_offset = 90, -- the higher the number, the higher the priority
          },
          path = {
            name = 'Path',
            module = 'blink.cmp.sources.path',
            score_offset = 25,
            fallbacks = { 'snippets', 'buffer' },
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
            name = 'Buffer',
            enabled = true,
            max_items = 3,
            module = 'blink.cmp.sources.buffer',
            min_keyword_length = 4,
            score_offset = 15, -- the higher the number, the higher the priority
          },
          dadbod = {
            name = 'Dadbod',
            module = 'vim_dadbod_completion.blink',
            score_offset = 85, -- the higher the number, the higher the priority
          },
          codecompanion = {
            name = 'CodeCompanion',
            module = 'codecompanion.providers.completion.blink',
            enabled = true,
          },
        },
        cmdline = function()
          local type = vim.fn.getcmdtype()
          if type == '/' or type == '?' then
            return { 'buffer' }
          end
          if type == ':' then
            return { 'cmdline' }
          end
          return {}
        end,
      },
      snippets = { preset = 'luasnip' },
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
      signature = { window = { border = vim.g.borderStyle } },
      enabled = function()
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
    },
    opts_extend = {
      'sources.default',
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  },
}
