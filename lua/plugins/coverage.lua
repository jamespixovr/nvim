return {
  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = 'VeryLazy',
    cmd = {
      'Coverage',
      'CoverageLoad',
      'CoverageLoadLcov',
      'CoverageShow',
      'CoverageHide',
      'CoverageToggle',
      'CoverageClear',
      'CoverageSummary',
    },
    opts = {
      auto_reload = true,
      lang = {
        go = {
          coverage_file = vim.fn.getcwd() .. '/coverage.out',
        },
      },
    },

    keys = {
      { '<leader>tcc', ':Coverage<CR>', desc = '[t]est [c]overage in gutter' },
      { '<leader>tcs', ':CoverageLoad<CR>:CoverageSummary<CR>', desc = '[t]est [C]overage summary' },
    },
  },
}
