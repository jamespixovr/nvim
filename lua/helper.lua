-- adapted from https://github.com/binhtran432k/nvim/blob/main/lua/helper.lua

local M = {}

M.root_patterns = { ".git", "/lua" }

function M.command(name, fn)
  vim.cmd(string.format("command! %s %s", name, fn))
end

function M.lua_command(name, fn)
  M.command(name, "lua " .. fn)
end

function M.is_directory()
  return vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1
end

local get_map_options = function(custom_options)
  local options = { noremap = true, silent = true }
  if custom_options then
    options = vim.tbl_extend("force", options, custom_options)
  end
  return options
end

M.buf_map = function(mode, target, source, opts, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr or 0, mode, target, source, get_map_options(opts))
end

M.nmap_buf = function(...)
  M.buf_map("n", ...)
end


---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

---get fg from vim
---@param name string
---@return function
function M.get_fg(name)
  return function()
    ---@type {foreground?:number}?
    local hl = vim.api.nvim_get_hl_by_name(name, true)
    return hl and hl.foreground and { fg = string.format("#%06x", hl.foreground) }
  end
end

---@param cmd string command to execute
---@param warn? string|boolean if vim.fn.executable <= 0 then warn with warn
function M.executable(cmd, warn)
  if vim.fn.executable(cmd) > 0 then
    return true
  end
  if warn then
    local message = type(warn) == "string" and warn or ("Command `%s` was not executable"):format(cmd)
    vim.notify(message, vim.log.levels.WARN, { title = "Executable not found" })
  end
  return false
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
          or client.config.root_dir and { client.config.root_dir }
          or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

---@param option string
---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  return function()
    if values then
      if vim.opt_local[option]:get() == values[1] then
        vim.opt_local[option] = values[2]
      else
        vim.opt_local[option] = values[1]
      end
      vim.notify(
        "Set " .. option .. " to " .. vim.opt_local[option]:get(),
        vim.log.levels.INFO,
        { title = "Option" }
      )
    else
      vim.opt_local[option] = not vim.opt_local[option]:get()
      if not silent then
        vim.notify(
          (vim.opt_local[option]:get() and "Enabled" or "Disabled") .. " " .. option,
          vim.log.levels.INFO,
          { title = "Option" }
        )
      end
    end
  end
end

local diagnostics_enabled = true

function M.toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled
  local msg
  if diagnostics_enabled then
    vim.diagnostic.enable()
    msg = "Enabled diagnostics"
  else
    vim.diagnostic.disable()
    msg = "Disabled diagnostics"
  end
  vim.notify(msg, vim.log.levels.INFO, { title = "Diagnostics" })
end

M.str_isempty = function(s)
  return s == nil or s == ""
end

-- Create a FileType autocommand event handler.
-- Examples:
-- ```lua
--    require("utils").on_ft("go", function(event)
--      vim.keymap.set("n", "<leader>dt", function()
--        require("dap-go").debug_test()
--      end, { desc = "debug test", buffer = event.buf })
--    end, "daptest")
-- ```
--- @param ft string|string[]
--- @param cb function|string
--- @param group? string
M.on_ft = function(ft, cb, group)
  local opts = { pattern = ft, callback = cb }
  if not M.str_isempty(group) then
    opts["group"] = group
    vim.api.nvim_create_augroup(opts["group"], { clear = false })
  end
  vim.api.nvim_create_autocmd("FileType", opts)
end

-- credit: https://github.com/ueaner/nvimrc/blob/main/lua/utils/init.lua
--- Extends a list-like table with the values of another list-like table.
---
---@see vim.tbl_extend()
---
---@param dst table List which will be modified and appended to
---@param src table List from which values will be inserted
---@param start? number Start index on src. Defaults to 1
---@param finish? number Final index on src. Defaults to `#src`
---@return table dst
M.list_extend = function(dst, src, start, finish)
  if type(dst) ~= "table" or type(src) ~= "table" then
    return dst
  end

  for i = start or 1, finish or #src do
    table.insert(dst, src[i])
  end
  return dst
end

--- Merge extended options with a default table of options
---@param default? table The default table that you want to merge into
---@param opts? table The new options that should be merged with the default table
---@return table # The merged table
function M.extend_tbl(default, opts)
  opts = opts or {}
  return default and vim.tbl_deep_extend("force", default, opts) or opts
end

--- A condition function if the current file is in a git repo
---@param bufnr table|integer a buffer number to check the condition for, a table with bufnr property, or nil to get the current buffer
---@return boolean # whether or not the current file is in a git repo
function M.is_git_repo(bufnr)
  if type(bufnr) == "table" then bufnr = bufnr.bufnr end
  return vim.b[bufnr or 0].gitsigns_head or vim.b[bufnr or 0].gitsigns_status_dict
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---send notification
---@param msg string
---@param title string
---@param level? "info"|"trace"|"debug"|"warn"|"error"
function M.notify(title, msg, level)
  if not level then level = "info" end
  vim.notify(msg, vim.log.levels[level:upper()], { title = title })
end

return M
