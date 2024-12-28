return {
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
