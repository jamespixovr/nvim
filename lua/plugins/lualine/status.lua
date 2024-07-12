local settings = require("settings")
local companion_lualine = require("plugins.lualine.helper")
local helper = require("helper")
local symbols = settings.icons
local lazy_status = require("lazy.status")
local colors = require("tokyonight.colors").setup()
-- local colors = require("catppuccin.palettes").get_palette("macchiato")

local M = {}

local modecolor = {
  n = colors.red,
  i = colors.cyan,
  v = colors.purple,
  -- [""] = colors.purple,
  V = colors.red,
  c = colors.yellow,
  no = colors.red,
  s = colors.yellow,
  S = colors.yellow,
  [""] = colors.yellow,
  ic = colors.yellow,
  R = colors.green,
  Rv = colors.purple,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ["r?"] = colors.cyan,
  ["!"] = colors.red,
  t = colors.red1,
}

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "recording @" .. recording_register
  end
end

local function getLspName()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_clients = vim.lsp.get_clients({ bufnr = bufnr })
  local buf_ft = vim.bo.filetype
  if next(buf_clients) == nil then
    return "  No servers"
  end
  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name ~= "null-ls" then
      table.insert(buf_client_names, client.name)
    end
  end

  local lint_s, lint = pcall(require, "lint")
  if lint_s then
    for ft_k, ft_v in pairs(lint.linters_by_ft) do
      if type(ft_v) == "table" then
        for _, linter in ipairs(ft_v) do
          if buf_ft == ft_k then
            table.insert(buf_client_names, linter)
          end
        end
      elseif type(ft_v) == "string" then
        if buf_ft == ft_k then
          table.insert(buf_client_names, ft_v)
        end
      end
    end
  end

  local ok, conform = pcall(require, "conform")
  local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
  if ok then
    for formatter in formatters:gmatch("%w+") do
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
  local language_servers = table.concat(unique_client_names, ", ")

  return "  " .. language_servers
end

function M.LazyUpdates(opts)
  return helper.extend_tbl({
    lazy_status.updates,
    padding = { left = 1, right = 1 },
    cond = lazy_status.has_updates,
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.mode(opts)
  return helper.extend_tbl({
    -- function()
    -- return settings.icons.ui.Target
    -- end,
    "mode",
    padding = { left = 0, right = 0 },
    -- color = { bg = "#282c34", fg = settings.colors.red, gui = "bold" },
    color = function()
      local mode_color = modecolor
      return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
    end,
    separator = { left = "", right = "" },
  }, opts)
end

function M.showMacroRecording(opts)
  return helper.extend_tbl({
    "macro-recording",
    fmt = show_macro_recording,
    separator = { left = "", right = "" },
    color = { bg = colors.purple, fg = colors.red, gui = "bold" },
  }, opts)
end

function M.branch(opts)
  return helper.extend_tbl({
    "b:gitsigns_head",
    icon = "",
    -- icon = "",
    separator = { left = "", right = "" },
    color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
    -- color = { bg = "#282c34", fg = settings.colors.blue, gui = "bold" },
    -- cond = helper.is_git_repo
  }, opts)
end

function M.progress(opts)
  return helper.extend_tbl({
    "progress",
    separator = { left = "", right = "" },
    color = { bg = colors.purple, fg = colors.bg, gui = "bold" },
  }, opts)
end

function M.datetime(opts)
  return helper.extend_tbl({
    function()
      return " " .. os.date("%R")
    end,
    padding = { left = 0, right = 0 },
    color = { bg = "#282c34", fg = settings.colors.blue, gui = "bold" },
  }, opts)
end

function M.searchCount(opts)
  return helper.extend_tbl({
    function()
      require("noice").api.status.search.get()
    end,
    cond = function()
      return package.loaded["noice"] and require("noice").api.status.search.has()
    end,
    color = { bg = "#282c34", fg = "#ff9e64", gui = "bold" },
  }, opts)
end

function M.codeium(opts)
  return helper.extend_tbl({
    function()
      return vim.fn["codeium#GetStatusString"]()
    end,
  }, opts)
end

function M.diagnostics(opts)
  return helper.extend_tbl({
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = {
      error = symbols.diagnostics.Error,
      warn = symbols.diagnostics.Warn,
      info = symbols.diagnostics.Info,
      hint = symbols.diagnostics.Hint,
    },
    padding = { left = 1, right = 1 },
    -- color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
    separator = { left = "", right = "" },
    -- color = { bg = "None" },
  }, opts)
end

function M.filetype(opts)
  return helper.extend_tbl({
    "filetype",
    icon_only = true,
    separator = "",
    padding = { left = 1, right = 0 },
    color = { fg = colors.cyan, gui = "italic,bold" },
    -- color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.filename(opts)
  return helper.extend_tbl({
    "filename",
    path = 1,
    shorting_target = 40,
    symbols = { modified = " ", readonly = " ", unnamed = " " },
    -- color = { fg = "#bcbcbc", gui = "bold" },
    color = { fg = colors.blue5, gui = "bold" },
    separator = { left = "", right = "" },
  }, opts)
end

function M.treesitter(opts)
  return helper.extend_tbl({
    function()
      return settings.icons.ui.Tree
    end,
    color = function()
      local buf = vim.api.nvim_get_current_buf()
      local ts = vim.treesitter.highlighter.active[buf]
      return { fg = ts and not vim.tbl_isempty(ts) and settings.colors.green or settings.colors.red, bg = "#282c34" }
    end,
  }, opts)
end

function M.git_diff(opts)
  return helper.extend_tbl({
    "diff",
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
      vim.cmd("DiffviewOpen")
    end,
    symbols = {
      added = symbols.git.added,
      modified = symbols.git.modified,
      removed = symbols.git.removed,
    }, -- changes diff symbols
    -- color = { bg = "None" },
    -- color = { bg = colors.gray2, fg = colors.bg, gui = "bold" },
    separator = { left = "", right = "" },

    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.yellow },
      removed = { fg = colors.red },
    },
    -- cond = helper.is_git_repo
  }, opts)
end

function M.lsp(opts)
  return helper.extend_tbl({
    function()
      return getLspName()
    end,
    on_click = function()
      vim.api.nvim_command("LspInfo")
    end,
    separator = { left = "", right = "" },
    color = function()
      local _, color = require("nvim-web-devicons").get_icon_cterm_color_by_filetype(
        vim.api.nvim_get_option_value("filetype", { buf = 0 })
      )
      return { fg = color }
    end,
    -- color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
  }, opts)
end

function M.scrollbar(opts)
  return helper.extend_tbl({
    function()
      local current_line = vim.fn.line(".")
      local total_lines = vim.fn.line("$")
      local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end,
    padding = { left = 0, right = 0 },
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
    cond = nil,
  }, opts)
end

function M.Overseer(opts)
  return helper.extend_tbl({
    "overseer",
    -- color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
    label = "", -- Prefix for task counts
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
      local dapStatus = require("dap").status()
      if dapStatus == "" then
        return ""
      end
      return "  " .. dapStatus
    end,
    -- color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.LintStatus(opts)
  return helper.extend_tbl({
    function()
      local linters = require("lint").get_running()
      if #linters == 0 then
        return "󰦕"
      end
      return "󱉶 " .. table.concat(linters, ", ")
    end,
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.codecompanion(opts)
  return helper.extend_tbl({
    companion_lualine,
    separator = { left = "", right = "" },
    color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
  }, opts)
end

return M
