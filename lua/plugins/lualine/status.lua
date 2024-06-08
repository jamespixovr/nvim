local settings = require("settings")
local helper = require('helper')
local symbols = settings.icons
local lazy_status = require("lazy.status")

local M = {}

local function show_macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == "" then
    return ""
  else
    return "recording @" .. recording_register
  end
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
    function()
      return settings.icons.ui.Target
    end,
    padding = { left = 0, right = 0 },
    color = { bg = "#282c34", fg = settings.colors.red, gui = "bold" },
  }, opts)
end

function M.showMacroRecording(opts)
  return helper.extend_tbl({
    "macro-recording",
    fmt = show_macro_recording,
    color = { bg = "#282c34", fg = settings.colors.red, gui = "bold" },
  }, opts)
end

function M.branch(opts)
  return helper.extend_tbl({
    "b:gitsigns_head",
    icon = "",
    -- icon = "",
    color = { bg = "#282c34", fg = settings.colors.blue, gui = "bold" },
    -- cond = helper.is_git_repo
  }, opts)
end

function M.progress(opts)
  return helper.extend_tbl({
    "progress",
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
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
    function() require('noice').api.status.search.get() end,
    cond = function()
      return package.loaded['noice']
          and require('noice').api.status.search.has()
    end,
    color = { bg = "#282c34", fg = "#ff9e64", gui = "bold" },
  }, opts)
end

function M.codeium(opts)
  return helper.extend_tbl({
    function()
      return vim.fn["codeium#GetStatusString"]()
    end
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
    color = { bg = "None" }
  }, opts)
end

function M.filetype(opts)
  return helper.extend_tbl({
    "filetype",
    icon_only = true,
    separator = "",
    padding = { left = 1, right = 0 },
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.filename(opts)
  return helper.extend_tbl({
    "filename",
    path = 1,
    shorting_target = 40,
    symbols = { modified = " ", readonly = " ", unnamed = " " },
    color = { fg = "#bcbcbc", gui = "bold" },
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
    symbols = {
      added = symbols.git.added,
      modified = symbols.git.modified,
      removed = symbols.git.removed,
    }, -- changes diff symbols
    color = { bg = "None" }
    -- cond = helper.is_git_repo
  }, opts)
end

function M.lsp(opts)
  return helper.extend_tbl({
    function()
      local buf_clients = vim.lsp.get_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return "LSP Inactive"
      end

      -- local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end
      end


      local unique_client_names = table.concat(buf_client_names, ", ")
      local language_servers = string.format("%s", unique_client_names)

      return language_servers
    end,
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
    icon = settings.icons.lsp.ActiveLSP,
  }, opts)
end

function M.scrollbar(opts)
  return helper.extend_tbl({
    function()
      local current_line = vim.fn.line "."
      local total_lines = vim.fn.line "$"
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
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
    label = '',         -- Prefix for task counts
    colored = true,     -- Color the task icons and counts
    unique = false,     -- Unique-ify non-running task count by name
    name = nil,         -- List of task names to search for
    name_not = false,   -- When true, invert the name search
    status = nil,       -- List of task statuses to display
    status_not = false, -- When true, invert the status search
  }, opts)
end

function M.DapStatus(opts)
  return helper.extend_tbl({
    function()
      local dapStatus = require("dap").status()
      if dapStatus == "" then return "" end
      return "  " .. dapStatus
    end,
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

return M
