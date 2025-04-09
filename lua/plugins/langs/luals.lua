return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        cmd = 'LazyDev',
        dependencies = {
          { 'Bilal2453/luvit-meta' },
          { 'folke/snacks.nvim' },
        },
        opts = {
          library = {
            -- Or relative, which means they will be resolved from the plugin dir.
            'lazy.nvim',
            'luvit-meta/library',
            'neotest',
            'plenary',
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
            { path = 'snacks.nvim', words = { 'Snacks' } },
            { path = 'lazy.nvim', words = { 'LazyVim' } },
          },
        },
      },
    },
    ft = { 'lua' },
    opts = {
      -- make sure mason installs the server
      servers = {
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                special = { reload = 'require' },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.fn.expand('$VIMRUNTIME/lua'),
                  vim.fn.expand('$VIMRUNTIME/lua/vim/lsp'),
                  vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy',
                },
              },
              codeLens = {
                enable = true,
              },
              completion = {
                workspaceWord = true,
                callSnippet = 'Both',
                enable = true,
                showWord = 'Disable',
              },
              diagnostics = {
                groupSeverity = {
                  strong = 'Warning',
                  strict = 'Warning',
                },
                groupFileStatus = {
                  ['ambiguity'] = 'Opened',
                  ['await'] = 'Opened',
                  ['codestyle'] = 'None',
                  ['duplicate'] = 'Opened',
                  ['global'] = 'Opened',
                  ['luadoc'] = 'Opened',
                  ['redefined'] = 'Opened',
                  ['strict'] = 'Opened',
                  ['strong'] = 'Opened',
                  ['type-check'] = 'Opened',
                  ['unbalanced'] = 'Opened',
                  ['unused'] = 'Opened',
                },
                unusedLocalExclude = { '_*' },
                globals = { 'vim' },
              },
              misc = {
                parameters = {
                  '--log-level=trace',
                },
              },
              doc = {
                privateName = { '^_' },
              },
              hint = {
                enable = true, -- enabled inlay hints
                setType = false,
                paramType = true,
                paramName = 'Disable',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
              },
            },
          },
        },
      },
    },
  },
}
