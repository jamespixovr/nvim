local icons = require('lib.icons')
local keymaps = require('plugins.snacks.utils.snacks-keymaps')
---@diagnostic disable: undefined-global
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
      animate = { enabled = true },
      bigfile = {
        enabled = true,
        notify = true,
        size = 100 * 1024, -- 100 KB
      },
      bufdelete = { enabled = true },
      git = { enabled = true },
      gitbrowse = { enabled = true },
      scope = { enabled = true },
      indent = {
        enabled = true,
        char = '▎',
        animate = { enabled = false },
        indent = {
          only_current = true,
          only_scope = true,
        },
        scope = {
          enabled = true,
          only_current = true,
          only_scope = true,
          underline = false,
          hl = {
            'SnacksIndent1',
            'SnacksIndent2',
            'SnacksIndent3',
            'SnacksIndent4',
            'SnacksIndent5',
            'SnacksIndent6',
            'SnacksIndent7',
            'SnacksIndent8',
          },
        },
        chunk = {
          enabled = true,
          only_current = true,
        },
        -- filter for buffers, turn off the indents for markdown
        filter = function(buf)
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ''
            and vim.bo[buf].filetype ~= 'markdown'
        end,
      },
      notifier = {
        enabled = true,
        -- style = 'fancy',
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        margin = { top = 0, right = 1, bottom = 0 },
        padding = true,
        -- sort = { 'level', 'added' },
        -- level = vim.log.levels.TRACE,
        icons = {
          debug = icons.ui.Bug,
          error = icons.diagnostics.Error,
          info = icons.diagnostics.Information,
          trace = icons.ui.Bookmark,
          warn = icons.diagnostics.Warning,
        },
        style = 'compact',
        top_down = true,
        date_format = '%R',
        more_format = ' ↓ %d lines ',
        -- refresh = 50,
      },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      terminal = { enabled = true, win = { wo = { winbar = '' } } },
      rename = { enabled = true },
      words = { enabled = true, notify_jump = true },
      scratch = {
        enabled = true,
        name = 'SCRATCH',
        ft = function()
          if vim.bo.buftype == '' and vim.bo.filetype ~= '' then
            return vim.bo.filetype
          end
          return 'markdown'
        end,
        icon = nil,
        root = vim.fn.stdpath('data') .. '/scratch',
        autowrite = true,
        filekey = {
          cwd = true,
          branch = true,
          count = true,
        },
        win = {
          relative = 'editor',
          width = 120,
          height = 40,
          bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
          minimal = false,
          noautocmd = false,
          zindex = 20,
          wo = { winhighlight = 'NormalFloat:Normal' },
          border = 'rounded',
          title_pos = 'center',
          footer_pos = 'center',

          keys = {
            ['execute'] = {
              '<cr>',
              function(_)
                vim.cmd('%SnipRun')
              end,
              desc = 'Execute buffer',
              mode = { 'n', 'x' },
            },
          },
        },
        win_by_ft = {
          lua = {
            keys = {
              ['source'] = {
                '<cr>',
                function(self)
                  local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
                  Snacks.debug.run({ buf = self.buf, name = name })
                end,
                desc = 'Source buffer',
                mode = { 'n', 'x' },
              },
              ['execute'] = {
                'e',
                function(_)
                  vim.cmd('%SnipRun')
                end,
                desc = 'Execute buffer',
                mode = { 'n', 'x' },
              },
            },
          },
        },
      },
    },
    keys = keymaps(),
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option('spell', { name = 'Spelling' }):map('<leader>us')
          Snacks.toggle.option('wrap', { name = 'Wrap' }):map('<leader>uw')
          Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map('<leader>uL')
          Snacks.toggle.diagnostics():map('<leader>ud')
          Snacks.toggle.line_number():map('<leader>ul')
          Snacks.toggle
            .option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map('<leader>uc')
          Snacks.toggle.treesitter():map('<leader>uT')
          Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map('<leader>ub')
          Snacks.toggle.inlay_hints():map('<leader>uh')
          Snacks.toggle.indent():map('<leader>ug')
        end,
      })
    end,
  },
}
