return {
  {
    'mfussenegger/nvim-lint',
    event = 'BufReadPre',
    config = function()
      require('lint').linters_by_ft = {
        -- python = { "ruff" },
        dockerfile = { 'hadolint' },
        htmldjango = { 'djlint' },
        lua = { 'selene' },
        sh = { 'shellcheck' },
        markdown = { 'markdownlint' },
        ['css'] = { 'stylelint' },
        ['scss'] = { 'stylelint' },
        ['less'] = { 'stylelint' },
        sql = { 'sqlfluff' },
        yaml = { 'yamllint' },
      }

      vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'BufReadPost' }, {
        callback = function()
          local lint_status, lint = pcall(require, 'lint')
          if lint_status then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
