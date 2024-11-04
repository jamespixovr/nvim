return {
  {
    'stevearc/conform.nvim',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'prettierd', 'mdformat' })
        end,
      },
    },
    ft = { 'markdown' },
    opts = {
      formatters_by_ft = {
        markdown = { 'prettierd' },
      },
      formatters = {
        prettierd = {
          -- https://prettier.io/docs/en/options.html
          prepend_args = { '--prose-wrap', 'always', '--print-width', '120', '--tab-width', '2' },
        },
        mdformat = {
          -- https://github.com/einride/sage/blob/master/tools/sgmdformat/tools.go
          prepend_args = { '--number', '--wrap', '80' },
        },
      },
    },
  },

  {
    'mfussenegger/nvim-lint',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { 'markdownlint', 'markdown-toc' })
        end,
      },
    },
    ft = { 'markdown' },
    opts = {
      linters_by_ft = {
        markdown = { 'markdownlint', 'markdown-toc' },
      },
    },
  },
}
