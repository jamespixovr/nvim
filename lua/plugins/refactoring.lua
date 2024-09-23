return {
  {
    'ThePrimeagen/refactoring.nvim', -- Refactor code like Martin Fowler
    keys = {
      {
        '<Leader>re',
        function()
          ---@diagnostic disable-next-line: missing-parameter
          require('refactoring').select_refactor()
        end,
        desc = 'Open Refactoring',
        mode = { 'n', 'v', 'x' },
      },
      {
        '<Leader>rf',
        function()
          require('refactoring').debug.cleanup({})
        end,
        desc = 'Refactor Clean up',
        mode = { 'n' },
      },
    },
    opts = {
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
      },
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
      },
      extract_var_statements = {
        go = '%s := %s',
      },
    },
    config = function()
      require('telescope').load_extension('refactoring')
    end,
  },
}
