-- Auto goimports with gopls
-- https://github.com/neovim/nvim-lspconfig/issues/115#issuecomment-1128115341
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim-imports
--[[
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.go' },
        callback = function()
          local params = vim.lsp.util.make_range_params()
          local wait_ms = 500
          params.context = { only = { 'source.organizeImports' } }
          local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, wait_ms)
          for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
              if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
              end
            end
          end
        end,
      })
      ]]

---@type vim.lsp.Config
local config = {
  init_options = {
    usePlaceholders = true,
    semanticTokens = true,
    staticcheck = true,
    experimentalPostfixCompletions = true,
    directoryFilters = {
      '-node_modules',
    },
    analyses = {
      nilness = true,
      unusedparams = true,
      unusedwrite = true,
    },
    codelenses = {
      gc_details = true,
      test = true,
      tidy = true,
    },
    hints = {
      assignVariableTypes = true,
      compositeLiteralTypes = true,
      constantValues = true,
      parameterNames = true,
      rangeVariableTypes = true,
    },
  },
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#settings
  settings = {
    env = { GOEXPERIMENT = 'rangefunc' },
    gopls = {
      codelenses = {
        gc_details = true, -- Show a code lens toggling the display of gc's choices.
        generate = true, -- show the `go generate` lens.
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = { -- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      -- https://github.com/golang/tools/blob/master/gopls/doc/inlayHints.md
      -- check if this works?
      ['ui.inlayhint.hints'] = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeValuesTypes = true,
      },
      analyses = {
        fieldalignment = false,
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        shadow = true,
        unusedvariable = true,
        fillreturns = true,
        nonewvars = true,
        undeclaredname = true,
        unreachable = true,
        ST1000 = false,
        -- Variable naming convention check
        ST1003 = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      directoryFilters = { '-**/node_modules', '-**/.git', '-.vscode', '-.idea', '-.vscode-test' },
      -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
      semanticTokens = false, -- disabling this enables treesitter injections (for sql, json etc)
      symbolMatcher = 'fuzzy',
      buildFlags = { '-tags', 'integration' },
      diagnosticsDelay = '500ms',
      matcher = 'Fuzzy',

      -- diagnostic options
      -- https://github.com/golang/tools/blob/master/gopls/internal/settings/settings.go
      staticcheck = true,
      vulncheck = 'imports',
      analysisProgressReporting = true,
    },
  },
}

return config
