local icons = require('lib.icons')

---@module 'snacks.input'
return {
  'folke/snacks.nvim',
  opts = {
    ---@type table<string, snacks.win.Config>
    styles = {
      input = {
        backdrop = 50,
        border = vim.g.borderStyle,
        title_pos = 'left',
        width = 50,
        row = math.ceil(vim.o.lines / 2) - 3,
        wo = { colorcolumn = '' },
        keys = {
          -- CR = { '<CR>', 'confirm', mode = 'n' },
        },
      },
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
      notification_history = {
        border = vim.g.borderStyle,
        zindex = 100,
        width = 0.6,
        height = 0.6,
        minimal = false,
        title = ' Notification History ',
        title_pos = 'center',
        ft = 'markdown',
        bo = { filetype = 'snacks_notif_history', modifiable = false },
        wo = { winhighlight = 'Normal:SnacksNotifierHistory' },
        keys = { q = 'close' },
      },
      float = {
        position = 'float',
        backdrop = 60,
        height = 0.9,
        width = 0.9,
        zindex = 50,
      },
      above_cursor = {
        backdrop = 50,
        position = 'float',
        border = vim.g.borderStyle,
        title_pos = 'left',
        height = 1,
        noautocmd = true,
        relative = 'cursor',
        width = 60,
        row = -3,
        col = 0,
        wo = {
          cursorline = false,
        },
        bo = {
          filetype = 'snacks_input',
          buftype = 'prompt',
        },
        --- buffer local variables
        b = {
          completion = false, -- disable blink completions in input
        },
        keys = {
          n_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'n', expr = true },
          i_esc = { '<esc>', { 'cmp_close', 'stopinsert' }, mode = 'i', expr = true },
          i_cr = { '<cr>', { 'cmp_accept', 'confirm' }, mode = 'i', expr = true },
          i_tab = { '<tab>', { 'cmp_select_next', 'cmp' }, mode = 'i', expr = true },
          i_ctrl_w = { '<c-w>', '<c-s-w>', mode = 'i', expr = true },
          i_up = { '<up>', { 'hist_up' }, mode = { 'i', 'n' } },
          i_down = { '<down>', { 'hist_down' }, mode = { 'i', 'n' } },
          q = 'cancel',
        },
      },
    },
    input = {
      enabled = true,
      icon = icons.ui.Edit,
      icon_hl = 'SnacksInputIcon',
      win = {
        style = 'above_cursor',
      },
    },
  },
}

-- input = {
--   enabled = true,
--   icon_hl = 'SnacksInputIcon',
--   icon_pos = 'left',
--   prompt_pos = 'title',
--   win = { style = 'input' },
--   expand = true,
-- },
