local mason_packages = vim.fn.stdpath('data') .. '/mason/packages'
local volar_path = mason_packages .. '/vue-language-server/node_modules/@vue/language-server'
-- local extractedTsserver = mason_packages .. "/typescript-language-server/node_modules/typescript/lib"

local constants = require('helpers.constants')

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vim.fn.stdpath('data') .. '/mason/packages/vue-language-server/node_modules/@vue/language-server',
  languages = { 'vue' },
  configNamespace = 'typescript',
}

---@type vim.lsp.Config
local config = {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
      tsserver = {
        globalPlugins = {
          vue_plugin,
        },
      },
    },
    typescript = {
      importModuleSpecifier = 'relative',
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = 'literals' },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
    javascript = {
      importModuleSpecifier = 'relative',
      updateImportsOnFileMove = { enabled = 'always' },
      suggest = {
        completeFunctionCalls = true,
      },
      implicitProjectConfig = {
        checkJs = true,
        strictNullChecks = false,
        strictFunctionTypes = false,
      },
      lib = {
        'ES2020',
        'DOM',
      },
    },
  },
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = volar_path,
        languages = { 'javascript', 'typescript', 'vue', 'tsx', 'jsx', 'typescriptreact' },
      },
    },
  },
  filetypes = constants.javascript_aliases,
  single_file_support = false,
  commands = {
    -- sent after organize-imports but never advertised, so Neovim warns once per session without this
    ['_typescript.didOrganizeImports'] = function() end,
  },
  handlers = {
    ['textDocument/publishDiagnostics'] = function(_, result, ctx, config)
      if result.diagnostics == nil then
        return
      end

      -- ignore some ts_ls / tsserver diagnostics
      local idx = 1
      while idx <= #result.diagnostics do
        local entry = result.diagnostics[idx]

        local formatter = require('format-ts-errors')[entry.code]
        entry.message = formatter and formatter(entry.message) or entry.message

        -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
        if entry.code == 80001 then
          -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
          table.remove(result.diagnostics, idx)
        else
          idx = idx + 1
        end
      end

      vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
    end,
  },
}

return config
