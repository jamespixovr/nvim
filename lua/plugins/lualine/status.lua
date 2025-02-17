local color = require('lib.colors')
local colors = require('catppuccin.palettes').get_palette('mocha')
local companion_lualine = require('plugins.lualine.helper')
local helper = require('helper')
local icons = require('lib.icons')
local lazy_status = require('lazy.status')

local M = {}

local mode_map = {
  ['NORMAL'] = 'N',
  ['O-PENDING'] = 'N?',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-BLOCK'] = 'VB',
  ['V-LINE'] = 'VL',
  ['V-REPLACE'] = 'VR',
  ['REPLACE'] = 'R',
  ['COMMAND'] = '!',
  ['SHELL'] = 'SH',
  ['TERMINAL'] = 'T',
  ['EX'] = 'X',
  ['S-BLOCK'] = 'SB',
  ['S-LINE'] = 'SL',
  ['SELECT'] = 'S',
  ['CONFIRM'] = 'Y?',
  ['MORE'] = 'M',
}

local modecolor = {
  n = colors.red,
  i = colors.cyan,
  v = colors.purple,
  V = colors.red,
  c = colors.yellow,
  no = colors.red,
  s = colors.yellow,
  S = colors.yellow,
  [''] = colors.yellow,
  ic = colors.yellow,
  R = colors.green,
  Rv = colors.purple,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ['r?'] = colors.cyan,
  ['!'] = colors.red,
  t = colors.red1,
}

local function quickfixCounter()
  local qf = vim.fn.getqflist({ idx = 0, title = true, items = true })
  if #qf.items == 0 then
    return ''
  end

  local qfBuffers = vim.tbl_map(function(item)
    return item.bufnr
  end, qf.items)
  local fileCount = #vim.fn.uniq(qfBuffers) -- qf-Buffers are already sorted
  local fileStr = fileCount > 1 and (' 「%s  」'):format(fileCount) or ''

  qf.title = qf -- prettify telescope's title output
    .title
    :gsub('^Live Grep: .-%((.+)%)', '%1') -- remove telescope prefixes
    :gsub('^Find Files: .-%((.+)%)', '%1')
    :gsub('^Find Word %((.-)%) %b()', '%1')
    :gsub(' %(%)', '') -- empty brackets
    :gsub('%-%-[%w-_]+ ?', '') -- remove flags from `makeprg`
  return (' %s/%s "%s"'):format(qf.idx, #qf.items, qf.title) .. fileStr
end

local function filenameAndIcon()
  local maxLength = 35 --CONFIG
  local name = vim.fs.basename(vim.api.nvim_buf_get_name(0))
  local display = #name < maxLength and name or vim.trim(name:sub(1, maxLength)) .. '…'
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return display
  end
  local extension = name:match('%w+$')
  local icon = devicons.get_icon(display, extension) or devicons.get_icon(display, vim.bo.ft)
  if not icon then
    return display
  end
  return icon .. ' ' .. display
end

local function getLspName()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return '  No servers'
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= 'null-ls' then
      table.insert(buf_client_names, client.name)
    end
  end

  local lint_s, lint = pcall(require, 'lint')
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == 'table' then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == 'string' then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local ok, conform = pcall(require, 'conform')
  local formatters = table.concat(conform.list_formatters_for_buffer(), ' ')
  if ok then
    for formatter in formatters:gmatch('%w+') do
      if formatter then
        table.insert(buf_client_names, formatter)
      end
    end
  end

  local hash = {}
  local unique_client_names = {}

  for _, v in ipairs(buf_client_names) do
    if not hash[v] then
      unique_client_names[#unique_client_names + 1] = v
      hash[v] = true
    end
  end
  local language_servers = table.concat(unique_client_names, ', ')

  return '  ' .. language_servers
end

function M.LazyUpdates(opts)
  return helper.extend_tbl({
    lazy_status.updates,
    padding = { left = 1, right = 1 },
    cond = lazy_status.has_updates,
    color = { bg = '#282c34', fg = '#bbc2cf', gui = 'bold' },
  }, opts)
end

function M.mode(opts)
  return helper.extend_tbl({
    'mode',
    fmt = function(s)
      return mode_map[s] or s
    end,
    padding = { left = 0, right = 0 },
    color = function()
      local mode_color = modecolor
      return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = 'bold' }
    end,
    separator = { left = '', right = '' },
  }, opts)
end

function M.showMacroRecording(opts)
  return helper.extend_tbl({
    function()
      return '雷Recording…'
    end,
    cond = function()
      return vim.fn.reg_recording() ~= ''
    end,
    separator = { left = '', right = '' },
    color = { bg = colors.red, fg = colors.bg_dark, gui = 'bold' },
  }, opts)
end

function M.branch(opts)
  return helper.extend_tbl({
    'b:gitsigns_head',
    icon = '',
    -- icon = "",
    separator = { left = '', right = '' },
    color = { bg = colors.purple, fg = colors.bg, gui = 'italic,bold' },
  }, opts)
end

function M.progress(opts)
  return helper.extend_tbl({
    'progress',
    separator = { left = '', right = '' },
    color = { bg = colors.purple, fg = colors.bg, gui = 'bold' },
  }, opts)
end

function M.datetime(opts)
  return helper.extend_tbl({
    function()
      return ' ' .. os.date('%R')
    end,
    padding = { left = 0, right = 0 },
    color = { bg = '#282c34', fg = color.blue, gui = 'bold' },
  }, opts)
end

function M.searchCount(opts)
  return helper.extend_tbl({
    'searchcount',
    color = { bg = '#282c34', fg = '#ff9e64', gui = 'bold' },
  }, opts)
end

function M.codeium(opts)
  return helper.extend_tbl({
    function()
      return vim.fn['codeium#GetStatusString']()
    end,
  }, opts)
end

function M.diagnostics(opts)
  return helper.extend_tbl({
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    draw_empty = false,
    symbols = {
      error = icons.diagnostics.Error,
      warn = icons.diagnostics.Warn,
      info = icons.diagnostics.Info,
      hint = icons.diagnostics.Hint,
    },
    padding = { left = 1, right = 1 },
    -- color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
    separator = { left = '', right = '' },
    -- color = { bg = "None" },
  }, opts)
end

function M.filetype(opts)
  return helper.extend_tbl({
    'filetype',
    icon_only = true,
    separator = '',
    padding = { left = 1, right = 0 },
    color = { fg = colors.cyan, gui = 'italic,bold' },
    -- color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.filename(opts)
  return helper.extend_tbl({
    filenameAndIcon,
    -- "filename",
    -- path = 1,
    -- shorting_target = 40,
    -- symbols = { modified = " ", readonly = " ", unnamed = " " },
    -- color = { fg = "#bcbcbc", gui = "bold" },
    color = { fg = colors.blue5, gui = 'bold' },
    separator = { left = '', right = '' },
  }, opts)
end

function M.treesitter(opts)
  return helper.extend_tbl({
    function()
      return icons.ui.Tree
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and color.green or color.red, bg = '#282c34' }
    end,
  }, opts)
end

function M.git_diff(opts)
  return helper.extend_tbl({
    'diff',
    source = function()
      ---@diagnostic disable-next-line: undefined-field
      local gitsigns = vim.b.gitsigns_status_dict
      if gitsigns then
        return {
          added = gitsigns.added,
          modified = gitsigns.changed,
          removed = gitsigns.removed,
        }
      end
    end,
    on_click = function()
      vim.cmd('DiffviewOpen')
    end,
    symbols = {
      added = icons.git.added,
      modified = icons.git.modified,
      removed = icons.git.removed,
    },
    separator = { left = '', right = '' },

    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    -- cond = helper.is_git_repo
  }, opts)
end

function M.codecompanion(opts)
  return helper.extend_tbl({
    companion_lualine,
    separator = { left = '', right = '' },
    color = { bg = colors.red, fg = colors.bg_dark, gui = 'italic,bold' },
  }, opts)
end

function M.lsp(opts)
  return helper.extend_tbl({
    function()
      return getLspName()
    end,
    on_click = function()
      vim.api.nvim_command('LspInfo')
    end,
    separator = { left = '', right = '' },
    color = function()
      local _, ftcolor = require('nvim-web-devicons').get_icon_cterm_color_by_filetype(
        vim.api.nvim_get_option_value('filetype', { buf = 0 })
      )
      return { fg = ftcolor }
    end,
  }, opts)
end

function M.scrollbar(opts)
  return helper.extend_tbl({
    function()
      local current_line = vim.fn.line('.')
      local total_lines = vim.fn.line('$')
      local chars = { '__', '▁▁', '▂▂', '▃▃', '▄▄', '▅▅', '▆▆', '▇▇', '██' }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = { bg = '#282c34', fg = '#bbc2cf', gui = 'bold' },
    cond = nil,
  }, opts)
end

function M.Overseer(opts)
  return helper.extend_tbl({
    'overseer',
    -- color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
    label = '', -- Prefix for task counts
    colored = true, -- Color the task icons and counts
    unique = false, -- Unique-ify non-running task count by name
    name = nil, -- List of task names to search for
    name_not = false, -- When true, invert the name search
    status = nil, -- List of task statuses to display
    status_not = false, -- When true, invert the status search
  }, opts)
end

function M.DapStatus(opts)
  return helper.extend_tbl({
    function()
      local dapStatus = require('dap').status()
      if dapStatus == '' then
        return ''
      end
      return '  ' .. dapStatus
    end,
    cond = function()
      return package.loaded['dap'] and require('dap').status() ~= ''
    end,
    color = { bg = colors.purple, fg = colors.bg, gui = 'italic,bold' },
  }, opts)
end

function M.LintStatus(opts)
  return helper.extend_tbl({
    function()
      local linters = require('lint').get_running()
      if #linters == 0 then
        return '󰦕'
      end
      return '󱉶 ' .. table.concat(linters, ', ')
    end,
    color = { bg = '#282c34', fg = '#bbc2cf', gui = 'bold' },
  }, opts)
end

function M.quickfixCounter(opts)
  return helper.extend_tbl({
    quickfixCounter,
    separator = { left = '', right = '' },
    color = { bg = colors.purple, fg = colors.bg, gui = 'italic,bold' },
  }, opts)
end

function M.pythonEnv(opts)
  return helper.extend_tbl({
    function()
      return '󱥒'
    end,
    cond = function()
      return vim.env.VIRTUAL_ENV and vim.bo.ft == 'python'
    end,
    padding = { left = 1, right = 0 },
  }, opts)
end

return M
