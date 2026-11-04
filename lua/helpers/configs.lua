local M = {}

--- Resolve a config file in the global `.linter_configs/` directory, creating it
--- from `default_content` when it is missing and content was supplied.
--- @param filename string Name of the file inside `.linter_configs/`
--- @param default_content string|nil Written when the file does not exist yet
--- @return string|nil path Readable config path, or nil when there is none
function M.ensure_global_config_exists(filename, default_content)
  local config_dir = vim.fn.stdpath('config') .. '/.linter_configs/'
  local config_path = vim.fn.expand(config_dir .. filename)

  if vim.fn.filereadable(config_path) == 1 then
    return config_path
  end

  -- No file and no content to seed it with: let the caller fall back to tool defaults
  if default_content == nil then
    return nil
  end

  vim.fn.mkdir(config_dir, 'p')
  local file = io.open(config_path, 'w')
  if not file then
    vim.notify('Failed to create global config: ' .. config_path, vim.log.levels.ERROR)
    return nil
  end
  file:write(default_content)
  file:close()
  return config_path
end

--- Project-local markdownlint config found upward from `dirname`, falling back to
--- the global `.linter_configs/markdownlint.jsonc`.
--- @param dirname string
--- @return string|nil path
function M.markdownlint_config(dirname)
  local local_config = vim.fs.find({
    '.markdownlint.json',
    '.markdownlint.jsonc',
    '.markdownlint.yaml',
    '.markdownlint.yml',
  }, { upward = true, path = dirname })[1]

  return local_config or M.ensure_global_config_exists('markdownlint.jsonc')
end

return M
