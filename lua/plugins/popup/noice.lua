-- noicer lua
-- DOCS https://github.com/folke/noice.nvim#-routes
local routes = {
  -- REDIRECT TO POPUP
  {
    filter = {
      min_height = 10,
      ['not'] = {
        cond = function(msg)
          local title = (msg.opts and msg.opts.title) or ''
          return title:find('Commit Preview') or title:find('tinygit') or title:find('Changed Files')
        end,
      },
    },
    view = 'popup',
  },
  -- output from `:Inspect`
  { filter = { event = 'msg_show', find = 'Treesitter.*- @' }, view = 'popup' },
  {
    filter = {
      any = {
        { find = 'No active Snippet' },
        { find = 'No signature help available' },
        { find = '^<$' },
        { kind = 'wmsg' },
      },
    },
    opts = { skip = true },
  },
  -----------------------------------------------------------------------------
  -- REDIRECT TO MINI

  -- write/deletion messages
  { filter = { event = 'msg_show', find = '%d+B written$' }, view = 'mini' },
  { filter = { event = 'msg_show', find = '%d+L, %d+B$' }, view = 'mini' },
  { filter = { event = 'msg_show', find = '%-%-No lines in buffer%-%-' }, view = 'mini' },

  -- search pattern not found
  { filter = { event = 'msg_show', find = '^E486: Pattern not found' }, view = 'mini' },

  -- Word added to spellfile via `zg`
  { filter = { event = 'msg_show', find = '^Word .*%.add$' }, view = 'mini' },

  { -- Mason
    filter = {
      event = 'notify',
      cond = function(msg)
        return msg.opts and (msg.opts.title or ''):find('mason')
      end,
    },
    view = 'mini',
  },

  -- nvim-treesitter
  { filter = { event = 'msg_show', find = '^%[nvim%-treesitter%]' }, view = 'mini' },
  { filter = { event = 'notify', find = 'All parsers are up%-to%-date' }, view = 'mini' },

  -----------------------------------------------------------------------------
  -- SKIP

  -- FIX LSP bugs?
  { filter = { event = 'msg_show', find = 'lsp_signature? handler RPC' }, skip = true },
  {
    filter = { event = 'msg_show', find = '^%s*at process.processTicksAndRejections' },
    skip = true,
  },

  -- code actions
  { filter = { event = 'notify', find = 'No code actions available' }, skip = true },

  -- unneeded info on search patterns
  { filter = { event = 'msg_show', find = '^[/?].' }, skip = true },

  -- E211 no longer needed, since auto-closing deleted buffers
  { filter = { event = 'msg_show', find = 'E211: File .* no longer available' }, skip = true },
  {
    filter = {
      event = 'msg_show',
      any = {
        { find = '%d+L, %d+B' },
        { find = '; after #%d+' },
        { find = '; before #%d+' },
        { find = '%d fewer lines' },
        { find = '%d more lines' },
      },
    },
    opts = { skip = true },
  },
}

--------------------------------------------------------------------------------
return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      -- 'rcarriga/nvim-notify',
    },
    opts = {
      routes = routes,
      cmdline = {
        format = {
          search_down = { icon = '  ' },
          search_up = { icon = '  ' },
          filter = { icon = '  ' },
          lua = { icon = '  ' },
          cmdline = { pattern = '^:', icon = '|>', lang = 'vim', title = '' },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = 15,
            col = '50%',
          },
          size = {
            width = '75%',
            height = 'auto',
          },
          border = { style = vim.g.borderStyle },
        },
        popupmenu = {
          relative = 'editor',
          position = {
            row = '50%',
            col = '50%',
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = vim.g.borderStyle,
            padding = { 0, 1 },
          },
          -- win_options = {
          --   winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
          -- },
        },
        mini = {
          timeout = 3000,
          zindex = 4, -- lower, so it does not cover nvim-notify (zindex 50)
          position = { col = -3 }, -- to the left to avoid collision with scrollbar
          format = { '{title} ', '{message}' }, -- leave out "{level}"
        },
        hover = {
          border = { style = vim.g.borderStyle },
          size = { max_width = 80 },
          win_options = { scrolloff = 4, wrap = true },
        },
        popup = {
          border = { style = vim.g.borderStyle },
          size = { width = 90, height = 25 },
          win_options = { scrolloff = 8, wrap = true, concealcursor = 'nv' },
          close = { keys = { 'q', '<D-w>', '<D-9>', '<D-0>' } },
        },
        split = {
          enter = true,
          size = '50%',
          win_options = { scrolloff = 6 },
          close = { keys = { 'q', '<D-w>', '<D-9>', '<D-0>' } },
        },
      },
      lsp = {
        progress = { enabled = false },
        signature = { enabled = false },
        hover = { silent = true },
        -- ENABLE features
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = vim.g.cmploader == 'nvim-cmp',
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        cmdline_output_to_split = false,
        lsp_doc_border = true,
      },
    },
    keys = {
      {
        '<S-Enter>',
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        mode = 'c',
        desc = 'Redirect Cmdline',
      },
      {
        '<leader>nl',
        function()
          require('noice').cmd('last')
        end,
        desc = 'Noice Last Message',
      },
      {
        '<leader>nh',
        function()
          require('noice').cmd('history')
        end,
        desc = 'Noice History',
      },
      {
        '<leader>na',
        function()
          require('noice').cmd('all')
        end,
        desc = 'Noice All',
      },
      {
        '<leader>nd',
        function()
          require('noice').cmd('dismiss')
        end,
        desc = 'Dismiss All',
      },
      {
        '<c-f>',
        function()
          if not require('noice.lsp').scroll(4) then
            return '<c-f>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll forward',
        mode = { 'i', 'n', 's' },
      },
      {
        '<c-b>',
        function()
          if not require('noice.lsp').scroll(-4) then
            return '<c-b>'
          end
        end,
        silent = true,
        expr = true,
        desc = 'Scroll backward',
        mode = { 'i', 'n', 's' },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == 'lazy' then
        vim.cmd([[messages clear]])
      end
      require('noice').setup(opts)
    end,
  },
}
