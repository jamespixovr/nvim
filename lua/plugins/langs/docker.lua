return {

  {
    'mfussenegger/nvim-lint',
    lazy = true,
    ft = { 'dockerfile' },
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'hadolint' })
        end,
      },
    },
    opts = {
      linters_by_ft = {
        dockerfile = { 'hadolint' },
      },
    },
  },

  {
    'neovim/nvim-lspconfig',
    lazy = true,
    -- ft = {
    --   "dockerfile",
    --   -- "yaml",
    -- },
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
          {
            'williamboman/mason.nvim',
          },
        },
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, {
            'dockerls',
          })
        end,
      },
    },
    opts = {
      servers = {
        -- https://github.com/rcjsuen/dockerfile-language-server
        dockerls = {
          filetypes = { 'dockerfile' },
        },
      },
    },
  },
}
