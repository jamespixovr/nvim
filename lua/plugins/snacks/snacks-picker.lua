---@module 'snacks.picker'

local preferred = {
  'telescope_no_preview',
  'mivy',
  'telescope_preview',
  'telescope_vertical',
  'bottom',
  'default',
  'dropdown',
  'ivy',
  'ivy_split',
  'left',
  'right',
  'select',
  'sidebar',
  'telescope',
  'top',
  'vertical',
  'vscode',
}

---@type snacks.picker.layout.Config
local mivy = {
  layout = {
    box = 'vertical',
    backdrop = 50,
    row = -1,
    width = 0,
    height = 0.5,
    border = 'top',
    title = '{title} {live} {flags}',
    {
      box = 'horizontal',
      {
        box = 'vertical',
        { win = 'input', height = 2 },
        { win = 'list' },
      },
      { win = 'preview', title = '{preview}', width = vim.o.columns <= 125 and 0.7 or 0.55 },
    },
  },
}

---@type snacks.picker.layout.Config
local telescope_no_preview = {
  preset = 'telescope',
  previewer = false,
  reverse = false,
  ---@type snacks.layout.Box
  layout = {
    box = 'horizontal',
    backdrop = false,
    width = 0.4,
    height = 0.5,
    border = 'none',
    {
      box = 'vertical',
      border = vim.g.border.style,
      title = '{title} {live} {flags}',
      title_pos = 'center',
      { win = 'input', height = 1, border = 'bottom' },
      { win = 'list', title = ' Results ', title_pos = 'center', border = 'none' },
    },
  },
}

---@type snacks.picker.layout.Config
local telescope_preview = {
  preset = 'telescope_no_preview',
  layout = {
    box = 'horizontal',
    width = 0.9,
    height = 0.9,
    {
      box = 'vertical',
      border = vim.g.border.style,
      title = '{title} {live} {flags}',
      title_pos = 'center',
      { win = 'input', height = 1, border = 'bottom' },
      { win = 'list', title = ' Results ', title_pos = 'center', border = 'none' },
      {
        win = 'preview',
        title = '{preview:Preview}',
        height = 0.75,
        border = 'top',
        title_pos = 'center',
      },
    },
  },
}

---@type snacks.picker.layout.Config
local telescope_vertical = {
  preset = 'telescope_preview',
  layout = {
    box = 'horizontal',
    width = 0.9,
    height = 0.9,
    {
      box = 'vertical',
      border = vim.g.border.style,
      title = '{title} {live} {flags}',
      title_pos = 'center',
      { win = 'input', height = 1, border = 'bottom' },
      { win = 'list', title = ' Results ', title_pos = 'center', border = 'none' },
    },
    { win = 'preview', width = 0.65, title = '{preview:Preview}', title_pos = 'center', border = vim.g.border.style },
  },
}

---@param picker snacks.Picker
local function set_next_preferred_layout(picker)
  local layout_name = picker.resolved_layout and picker.resolved_layout.preset
  if layout_name then
    local idx = vim
      .iter(preferred)
      :enumerate()
      :filter(function(_, v)
        return v == layout_name
      end)
      :next()
    idx = idx % #preferred + 1
    picker:set_layout(preferred[idx])
  end
end

local function set_prev_preferred_layout(picker)
  local layout_name = picker.resolved_layout and picker.resolved_layout.preset
  if layout_name then
    local idx = vim
      .iter(preferred)
      :enumerate()
      :filter(function(_, v)
        return v == layout_name
      end)
      :next()
    idx = idx == 1 and #preferred or idx - 1
    picker:set_layout(preferred[idx])
  end
end

return {
  'folke/snacks.nvim',
  keys = {
    {
      '<c-p>',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<c-f>',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Find Files',
    },
  },
  opts = {
    ---@type snacks.picker.Config
    picker = {
      ui_select = true,
      formatters = {
        file = {
          filename_first = true,
          truncate = 100,
        },
      },
      enabled = true,
      prompt = '',
      sources = {
        grep_word = {
          layout = { preset = 'telescope_preview' },
        },
        grep = {
          layout = { preset = 'telescope_preview' },
        },
        commands = { layout = { preset = 'vscode' } },
        diagnostics = { layout = { preset = 'vertical' } },
        projects = {
          projects = {
            vim.fn.expand('~/Projects/PayAngel/StandApp/Nodejs'),
            vim.fn.expand('~/Projects/PAiC/extended'),
          },
          recent = true,
          dev = { '~/Projects/PayAngel/StandApp/Nodejs', '~/Projects/PAiC/extended' },
          patterns = { '.git', '.vscode', 'package.json', 'Makefile' },
          confirm = function(picker, item)
            picker:close()
            vim.cmd('cd ' .. item.file)
            Snacks.notify('Changed directory to: ' .. item.file)
          end,
        },
        todo_comments = {
          layout = {
            preset = function()
              return vim.o.columns >= 120 and 'mivy' or 'telescope_no_preview'
            end,
          },
        },
        keymaps = {
          layout = { preset = 'default' },
        },
      },
      layouts = {
        mivy = mivy,
        telescope_no_preview = telescope_no_preview,
        telescope_preview = telescope_preview,
        telescope_vertical = telescope_vertical,
      },
      layout = {
        reverse = false,
        cycle = true,
        --- Use the default layout or vertical if the window is too narrow
        preset = function()
          return vim.o.columns >= 120 and 'mivy' or 'vertical'
        end,
        border = 'rounded',
      },
      actions = {
        trouble_open = function(...)
          return require('trouble.sources.snacks').actions.trouble_open.action(...)
        end,
        cycle_next_layouts = function(picker)
          set_next_preferred_layout(picker)
        end,
        cycle_prev_layouts = function(picker)
          set_prev_preferred_layout(picker)
        end,
        flash = function(picker)
          require('flash').jump({
            pattern = '^',
            label = { after = { 0, 0 } },
            search = {
              mode = 'search',
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                end,
              },
            },
            action = function(match)
              local idx = picker.list:row2idx(match.pos[1])
              picker.list:_move(idx, true, true)
            end,
          })
        end,
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
            -- ['<C-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
            ['<c-h>'] = { 'cycle_next_layouts', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'cycle_prev_layouts', mode = { 'i', 'n' } },
            ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' } },
            ['<c-s>'] = { 'flash', mode = { 'n', 'i' } },
            ['<c-c>'] = { 'close', mode = { 'n', 'i' } },
            ['s'] = { 'flash' },
          },
        },
      },
    },
  },
}
