return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    keys = { { '<leader>lm', '<cmd>Mason<cr>', desc = 'Mason' } },
    build = ':MasonUpdate',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '✓',
          -- package_pending = "➜",
          package_pending = '⟳',
          package_uninstalled = '✗',
        },
      },
      ensure_installed = {
        'biome',
        'typos-lsp', -- spellchecker for code
        'codelldb',
        'css-lsp',
        'emmet-ls',
        'gopls',
        'html-lsp',
        'js-debug-adapter',
        'json-lsp',
        'lua-language-server',
        'luacheck',
        'prettier',
        'prettierd',
        'shellcheck',
        'shfmt',
        'stylua',
        'selene',
        'luacheck',
        'taplo',
        'typescript-language-server',
        'yaml-language-server',
        'yamllint',
        'csharpier',
        'netcoredbg',
        'sonarlint-language-server',
        -- Java stuff
        'jdtls',
        'java-debug-adapter',
        'java-test',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)
      local mr = require('mason-registry')

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
