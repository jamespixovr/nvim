local M = {}

---Check if a plugin has been loaded
---@param plugin string # The name of the plugin. It should be the same as the one you use in `require(plugin name)`
---@return boolean available # Whether the plugin is available
function M.is_available(plugin)
  return package.loaded[plugin] ~= nil
end

return M
