return {
  -- {
  --    'folke/which-key.nvim',
  --    optional = true,
  --    opts = {
  --      spec = {
  --        { '<leader>r', group = 'refactor' },
  --        { '<leader>rb', group = 'block' },
  --      },
  --    },
  --  },
  {
    'ThePrimeagen/refactoring.nvim', -- Refactor code like Martin Fowler
    enabled = true,
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>r', '', desc = '+refactor', mode = { 'n', 'v' } },
      {
        '<leader>rs',
        function()
          ---@diagnostic disable-next-line: missing-parameter
          require('refactoring').select_refactor()
        end,
        mode = 'v',
        desc = 'Refactor',
      },
      {
        '<leader>ri',
        function()
          require('refactoring').refactor('Inline Variable')
        end,
        mode = { 'n', 'v' },
        desc = 'Inline Variable',
      },
      {
        '<leader>rb',
        function()
          require('refactoring').refactor('Extract Block')
        end,
        desc = 'Extract Block',
      },
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
        '<leader>rP',
        function()
          require('refactoring').debug.printf({ below = false })
        end,
        desc = 'Debug Print',
      },
      {
        '<leader>rp',
        function()
          require('refactoring').debug.print_var({ normal = true })
        end,
        desc = 'Debug Print Variable',
      },
      {
        '<leader>rc',
        function()
          require('refactoring').debug.cleanup({})
        end,
        desc = 'Debug Cleanup',
      },
      {
        '<leader>rf',
        function()
          require('refactoring').refactor('Extract Function')
        end,
        mode = 'v',
        desc = 'Extract Function',
      },
      {
        '<leader>rF',
        function()
          require('refactoring').refactor('Extract Function To File')
        end,
        mode = 'v',
        desc = 'Extract Function To File',
      },
      {
        '<leader>rx',
        function()
          require('refactoring').refactor('Extract Variable')
        end,
        mode = 'v',
        desc = 'Extract Variable',
      },
      {
        '<leader>rp',
        function()
          ---@diagnostic disable-next-line: missing-parameter
          require('refactoring').debug.print_var()
        end,
        mode = 'v',
        desc = 'Debug Print Variable',
      },
    },
    opts = {
      prompt_func_return_type = {
        go = true,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      prompt_func_param_type = {
        go = false,
        java = false,
        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
      },
      printf_statements = {},
      print_var_statements = {},
      show_success_message = true, -- shows a message with information about the refactor on success
      extract_var_statements = {
        go = '%s := %s',
      },
    },
  },
}
