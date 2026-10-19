--- adapted from https://github.com/JustBarnt/nvim/

---@class helpers
---@field lsp helpers.lsp
---@field root helpers.root
---@field colors helpers.colors
---@field jvm helpers.jvm
---@field icons helpers.icons
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require('helpers.' .. k)
    return t[k]
  end,
})

---@param name string
function M.get_plugin(name)
  return require('lazy.core.config').spec.plugins[name]
end

---@param plugin string
---@return boolean # Whether the plugin is installed
function M.has(plugin)
  return M.get_plugin(plugin) ~= nil
end

---@param name string
function M.opts(name)
  local plugin = M.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require('lazy.core.plugin')
  return Plugin.values(plugin, 'opts', false)
end

function M.is_loaded(name)
  local Config = require('lazy.core.config')
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd('User', {
      pattern = 'LazyLoad',
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

--- builds a table from n tables given and removes any duplicates it finds and returns a merged table
---@param ... string[]
---@return string[]
function M.build_table(...)
  --- Flatten our n tables in to a single list
  ---@type string[]
  local list = vim.iter({ ... }):flatten(math.huge):totable()
  return M.dedup(list)
end

-- Wrapper around vim.keymap.set that will
-- not create a keymap if a lazy key handler exists
function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require('lazy.core.handler').handlers.keys
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == 'string' and { mode } or mode

  local exists = {}
  for _, m in ipairs(modes) do
    if keys.have and keys:have(lhs, m) then
      table.insert(exists, m)
    end
  end

  if #exists > 0 then
    vim.notify(
      ('Keymap for %s already exists in mode(s): %s, skipping'):format(lhs, table.concat(exists, ',')),
      vim.log.levels.WARN
    )
  end

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- Do not create keymaps if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

---@param filetype string[]
---@return boolean
function M.disable_item(filetype)
  local ft = vim.api.nvim_get_option_value('filetype', { buf = vim.api.nvim_get_current_buf() })
  if vim.tbl_contains(filetype, ft) then
    return false
  end
  return true
end

local cache = {} ---@type table<(fun()), table<string, any>>

---@generic T: fun()
---@param fn T
---@return T
function M.memoize(fn)
  return function(...)
    local key = vim.inspect({ ... })
    cache[fn] = cache[fn] or {}
    if cache[fn][key] == nil then
      cache[fn][key] = fn(...)
    end
    return cache[fn][key]
  end
end

---Try to require the module, but do not throw error when one of them cannot be
---loaded. This prevents the entire remaining config from not being loaded if
---just one module has an error.
---@param module string
function M.safeRequire(module)
  local success, errmsg = pcall(require, module)
  if not success then
    local msg = ('Error loading `%s`: %s'):format(module, errmsg)
    vim.defer_fn(function()
      vim.notify(msg, vim.log.levels.ERROR)
    end, 500)
  end
end

function M.command(name, fn)
  vim.cmd(string.format('command! %s %s', name, fn))
end

function M.lua_command(name, fn)
  M.command(name, 'lua ' .. fn)
end

function M.is_directory()
  return vim.fn.isdirectory(vim.api.nvim_buf_get_name(0)) == 1
end

---@param cmd string command to execute
---@param warn? string|boolean if vim.fn.executable <= 0 then warn with warn
---@return boolean
function M.executable(cmd, warn)
  if vim.fn.executable(cmd) > 0 then
    return true
  end
  if warn then
    local message = type(warn) == 'string' and warn or ('Command `%s` was not executable'):format(cmd)
    vim.notify(message, vim.log.levels.WARN, { title = 'Executable not found' })
  end
  return false
end

M.str_isempty = function(s)
  return s == nil or s == ''
end

return M
