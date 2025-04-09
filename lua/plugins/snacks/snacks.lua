local icons = require('lib.icons')

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
    keys = {
      -- stylua: ignore start
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>st", function()
          Snacks.scratch({ icon = " ", name = "Todo", ft = "markdown", file = "scatch-file.md" })
        end, desc = "Todo List" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>ns",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- { "<c-i>",     function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "TT",  function() Snacks.terminal() end, desc = "Toggle Terminal" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
      { '<leader>jg', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>/', function() Snacks.picker.grep() end, desc = 'Grep' },
      { '<leader>sb', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
      { '<leader>sh', function() Snacks.picker.grep_word() end, desc = 'Visual selection or word', mode = { 'n', 'x' } },
      { '<leader>jk', function() Snacks.picker.keymaps() end, desc = 'Keymaps', },
      { '<leader>rr', function() Snacks.picker.resume() end, desc = 'Resume' },
      { '<leader>jf', function() Snacks.picker.files() end, desc = 'Find Files' },
      { '<leader>:', function() Snacks.picker.commands() end, desc = 'Commands' },
      { '<leader>je', function() Snacks.picker.explorer() end, desc = 'Commands' },
      { '<leader>ff', function() Snacks.picker.smart({filter = {cwd = true}}) end, desc = 'Find Files', },
      { '<leader>bb', function() Snacks.picker.buffers({layout = { preset = 'select'}}) end, desc = 'Buffers', },
      { '<leader>sp', function() Snacks.picker({layout = { preset = 'vscode'}}) end, desc = 'Pickers', },
      { "<leader>ld", function() Snacks.picker.lsp_definitions():set_layout("vertical") end, desc = "Definition" },
      { "<leader>lr", function() Snacks.picker.lsp_references():set_layout("mivy") end, nowait = true, desc = "References" },
      { "<leader>lI", function() Snacks.picker.lsp_implementations():set_layout("mivy") end, desc = "Implementation" },
      { "<leader>lt", function() Snacks.picker.lsp_type_definitions():set_layout("mivy") end, desc = "Type Definition" },

      -- stylua: ignore end
    },
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
