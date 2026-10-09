---@type vim.lsp.Config
return {
  root_markers = {
    'pyproject.toml',
    'ruff.toml',
    '.ruff.toml',
    'requirements.txt',
    'uv.lock',
    'setup.py',
    'setup.cfg',
    'Pipfile',
    'pyrightconfig.json',
    '.git',
  },
  filetypes = { 'python' },
  -- root_dir = (function()
  --   return vim.fs.root(0, root_files)
  -- end)(),
  on_attach = function(client, bufnr)
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  -- HACK: explicitly setting offset encoding:
  -- https://github.com/astral-sh/ruff/issues/14483#issuecomment-2526717736
  capabilities = {
    general = {
      -- positionEncodings = { "utf-8", "utf-16", "utf-32" }  <--- this is the default
      positionEncodings = { 'utf-16' },
    },
  },
  init_options = {
    settings = {
      -- https://docs.astral.sh/ruff/editors/settings/
      configurationPreference = 'filesystemFirst',
      lineLength = 88,
      organizeImports = false, -- if "I" ruleset is added, already included in "fixAll"
      codeAction = { disableRuleComment = { enable = false } }, -- using nvim-rulebook instead
    },
  },
  settings = {
    ruff = {},
  },
}
