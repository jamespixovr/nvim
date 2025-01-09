local icons = require('lib.icons')
-- https://www.lazyvim.org/extras/coding/blink
-- https://github.com/saghen/blink.cmp
-- Documentation site: https://cmp.saghen.dev/

-- NOTE: Specify the trigger character(s) used for luasnip
local trigger_text = ';'

return {
  {
    'saghen/blink.cmp',
    build = 'cargo build --release',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'moyiz/blink-emoji.nvim',
    },
    event = { 'InsertEnter' },
    opts = function(_, opts)
      opts.sources = vim.tbl_deep_extend('force', opts.sources or {}, {
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
          snippets = {
            name = 'snippets',
            enabled = true,
            max_items = 8,
            min_keyword_length = 2,
            module = 'blink.cmp.sources.snippets',
            score_offset = 85, -- the higher the number, the higher the priority
            -- Only show snippets if I type the trigger_text characters, so
            -- to expand the "bash" snippet, if the trigger_text is ";" I have to
            -- type ";bash"
            should_show_items = function()
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              -- NOTE: remember that `trigger_text` is modified at the top of the file
              return before_cursor:match(trigger_text .. '%w*$') ~= nil
            end,
            -- After accepting the completion, delete the trigger_text characters
            -- from the final inserted text
            transform_items = function(_, items)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local before_cursor = vim.api.nvim_get_current_line():sub(1, col)
              local trigger_pos = before_cursor:find(trigger_text .. '[^' .. trigger_text .. ']*$')
              if trigger_pos then
                for _, item in ipairs(items) do
                  item.textEdit = {
                    newText = item.insertText or item.label,
                    range = {
                      start = { line = vim.fn.line('.') - 1, character = trigger_pos - 1 },
                      ['end'] = { line = vim.fn.line('.') - 1, character = col },
                    },
                  }
                end
              end
              -- NOTE: After the transformation, I have to reload the luasnip source
              -- Otherwise really crazy shit happens and I spent way too much time
              -- figurig this out
              vim.schedule(function()
                require('blink.cmp').reload('snippets')
              end)
              return items
            end,
          },
          -- Example on how to configure dadbod found in the main repo
          -- https://github.com/kristijanhusak/vim-dadbod-completion
          dadbod = {
            name = 'Dadbod',
            module = 'vim_dadbod_completion.blink',
            score_offset = 85, -- the higher the number, the higher the priority
          },
          -- https://github.com/moyiz/blink-emoji.nvim
          emoji = {
            module = 'blink-emoji',
            name = 'Emoji',
            score_offset = 15, -- the higher the number, the higher the priority
            opts = { insert = true }, -- Insert emoji (default) or complete its name
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
      })

      opts.snippets = {
        preset = 'luasnip',
        -- This comes from the luasnip extra, if you don't add it, won't be able to
        -- jump forward or backward in luasnip snippets
        -- https://www.lazyvim.org/extras/coding/luasnip#blinkcmp-optional
        expand = function(snippet)
          require('luasnip').lsp_expand(snippet)
        end,
        active = function(filter)
          if filter and filter.direction then
            return require('luasnip').jumpable(filter.direction)
          end
          return require('luasnip').in_snippet()
        end,
        jump = function(direction)
          require('luasnip').jump(direction)
        end,
      }

      -- The default preset used by lazyvim accepts completions with enter
      -- I don't like using enter because if on markdown and typing
      -- something, but you want to go to the line below, if you press enter,
      -- the completion will be accepted
      -- https://cmp.saghen.dev/configuration/keymap.html#default
      opts.keymap = {
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
      }

      opts.appearance = { use_nvim_cmp_as_default = true, nerd_font_variant = 'normal', kind_icons = icons.kind }
      opts.signature = { window = { border = vim.g.borderStyle } }
      opts.enabled = function()
        return not vim.tbl_contains({}, vim.bo.filetype)
          -- and vim.bo.buftype ~= 'nofile'
          and vim.bo.buftype ~= 'prompt'
          and vim.b.completion ~= false
      end

      opts.completion = {
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
      }

      return opts
    end,
    opts_extend = {
      'sources.default',
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  },
}
