local settings = require("settings")
local helper = require('helper')
local symbols = settings.icons

local M = {}

function M.mode(opts)
  return helper.extend_tbl({
    function()
      return " " .. settings.icons.ui.Target .. " "
    end,
    padding = { left = 0, right = 0 },
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
  }, opts)
end

function M.branch(opts)
  return helper.extend_tbl({
    "branch",
    icon = "",
    color = { gui = "bold" },
    -- cond = helper.is_git_repo
  }, opts)
end

function M.progress(opts)
  return helper.extend_tbl({
    "progress",
    color = { bg = "#282c34", fg = "#bbc2cf", gui = "bold" },
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
    padding = { left = 1, right = 1 }
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
    symbols = { modified = " ", readonly = " ", unnamed = " " }
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
      return { fg = ts and not vim.tbl_isempty(ts) and settings.colors.green or settings.colors.red }
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
    -- cond = helper.is_git_repo
  }, opts)
end

function M.lsp(opts)
  return helper.extend_tbl({
    function()
      local buf_clients = vim.lsp.get_active_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return "LSP Inactive"
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end
      end


      local unique_client_names = table.concat(buf_client_names, ", ")
      local language_servers = string.format("[%s]", unique_client_names)

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
    color = "SLProgress",
    cond = nil,
  }, opts)
end

return M
