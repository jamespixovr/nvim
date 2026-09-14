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
local small_no_preview = {
  layout = {
    box = 'horizontal',
    width = 0.6,
    height = 0.6,
    border = 'none',
    {
      box = 'vertical',
      border = vim.o.winborder --[[@as "rounded"|"single"|"double"|"solid"]],
      title = '{title} {live} {flags}',
      { win = 'input', height = 1, border = 'bottom' },
      { win = 'list', border = 'none' },
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

local function betterFileOpen()
  local changedFiles = {}
  local gitDir = Snacks.git.get_root()
  if gitDir then
    local args = { 'git', 'status', '--porcelain', '--ignored', '.' }
    local gitStatus = vim.system(args):wait().stdout
    local changes = vim.split(gitStatus or '', '\n', { trimempty = true })
    vim.iter(changes):each(function(line)
      local relPath = line:sub(4)
      local change = line:sub(1, 2)
      if change == '??' then
        change = ' A'
      end -- just nicer highlights for untracked
      if change:find('R') then
        relPath = relPath:gsub('.+ -> ', '')
      end -- renamed
      local absPath = gitDir .. '/' .. relPath
      changedFiles[absPath] = change
    end)
  end

  local currentFile = vim.api.nvim_buf_get_name(0)
  Snacks.picker.files({
    title = ' ' .. vim.fs.basename(vim.uv.cwd()),
    -- exclude the current file
    transform = function(item, _ctx)
      local itemPath = Snacks.picker.util.path(item)
      if itemPath == currentFile then
        return false
      end
    end,
    -- add git status and hidden status as highlights
    format = function(item, picker)
      local itemPath = Snacks.picker.util.path(item)
      item.status = changedFiles[itemPath]
      if vim.startswith(item.file, '.') then
        item.status = '!!'
      end -- hidden files
      return require('snacks.picker.format').file(item, picker)
    end,
  })
end

return {
  'folke/snacks.nvim',
  keys = {
    { 'go', betterFileOpen, desc = ' Open files' },
    {
      'g,',
      function()
        Snacks.picker.explorer()
      end,
      desc = '󰙅 File tree',
    },
    {
      '<c-p>',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    -- {
    --   '<c-f>',
    --   function()
    --     Snacks.picker.grep()
    --   end,
    --   desc = 'Find Files',
    -- },
    --------------------------------------------------------------------------
    -- INSPECT

    {
      '<leader>ih',
      function()
        Snacks.picker.highlights()
      end,
      desc = ' Highlights',
    },
    {
      '<leader>iv',
      function()
        Snacks.picker.help()
      end,
      desc = '󰋖 Vim help',
    },
    {
      '<leader>is',
      function()
        Snacks.picker.pickers()
      end,
      desc = '󰗲 Snacks pickers',
    },
    {
      '<leader>ik',
      function()
        Snacks.picker.keymaps()
      end,
      desc = '󰌌 Keymaps (global)',
    },
    {
      '<leader>iK',
      function()
        Snacks.picker.keymaps({ global = false, title = '󰌌 Keymaps (buffer)' })
      end,
      desc = '󰌌 Keymaps (buffer)',
    },
  },
  opts = {
    ---@type snacks.picker.Config
    picker = {
      ui_select = true,
      previewers = {
        diff = { builtin = false },
        git = { builtin = false },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 100,
        },
      },
      enabled = true,
      prompt = '',
      sources = {
        -- buffers = {
        --   layout = {
        --     preset = function()
        --       return vim.o.columns >= 120 and 'mivy' or 'dropdown'
        --     end,
        --   },
        -- },
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
            -- vim.fn.expand('~/Projects/PAiC/extended'),
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
          hidden = false,
          ignored = false,
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
        small_no_preview = small_no_preview,
        very_vertical = {
          preset = 'small_no_preview',
          layout = { height = 0.95, width = 0.45 },
        },
        wide_with_preview = {
          preset = 'small_no_preview',
          layout = {
            width = 0.99,
            [2] = { -- as second column
              win = 'preview',
              title = '{preview}',
              border = vim.o.winborder --[[@as "rounded"|"single"|"double"|"solid"]],
              width = 0.5,
              wo = { number = false, statuscolumn = ' ', signcolumn = 'no' },
            },
          },
        },
        toggled_preview = { ---@diagnostic disable-line: missing-fields
          preset = 'wide_with_preview',
          preview = false, ---@diagnostic disable-line: assign-type-mismatch wrong annotation
        },
        big_preview = {
          preset = 'wide_with_preview',
          layout = {
            height = 0.7,
            [2] = { width = 0.6 }, -- second win is the preview
          },
        },
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
      },
      win = {
        input = {
          keys = {
            ['<Esc>'] = { 'close', mode = { 'i', 'n' } },
            -- ['<C-h>'] = { 'toggle_hidden', mode = { 'i', 'n' } },
            ['<c-h>'] = { 'cycle_next_layouts', mode = { 'i', 'n' } },
            ['<c-l>'] = { 'cycle_prev_layouts', mode = { 'i', 'n' } },
            ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' } },
            ['<M-j>'] = { 'preview_scroll_down', mode = { 'i' } },
            ['<M-k>'] = { 'preview_scroll_up', mode = { 'i' } },
          },
        },
      },
    },
  },
}
