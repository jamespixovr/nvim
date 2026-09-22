local mason_packages = vim.fn.stdpath('data') .. '/mason/packages'
local extractedTsserver = mason_packages .. '/typescript-language-server/node_modules/typescript/lib'

---@type vim.lsp.Config
local config = {
  filetypes = { 'vue' },
  root_markers = { 'package.json' },
  init_options = {
    vue = { hybridMode = true },
    typescript = {
      tsdk = extractedTsserver,
    },
  },
  settings = {
    vue = {
      complete = {
        casing = {
          tags = 'kebab',
          props = 'kebab',
        },
      },
    },
  },
}

return config
