local M = {}

function M.keymaps()
  return {
    {
      '<leader>tn',
      "<cmd>lua require('neotest').run.run()<cr>",
      desc = 'Run nearest test',
    },
    {
      '<leader>tT',
      function()
        require('neotest').run.run(vim.loop.cwd())
      end,
      desc = 'Run All Test Files',
    },
    {
      '<leader>tb',
      function()
        require('neotest').run.run(vim.api.nvim_buf_get_name(0))
      end,
      mode = 'n',
      desc = 'Run test file',
    },
    {
      '<leader>tl',
      "<cmd>lua require('neotest').run.run_last()<cr>",
      desc = 'Run last test',
    },
    {
      '<leader>tf',
      '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>',
      desc = 'Run test file',
    },
    {
      '<leader>td',
      function()
        require('neotest').run.run({ strategy = 'dap' })
      end,
      desc = 'Debug test',
    },
    {
      '<leader>tD',
      "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
      desc = 'Debug File',
    },
    {
      '<leader>ta',
      "<cmd>lua require('neotest').run.attach()<cr>",
      desc = 'Attach test',
    },
    {
      '<leader>ts',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle Summary',
    },
    {
      '<leader>tx',
      "<cmd>lua require('neotest').stop()<cr>",
      desc = 'Stop test',
    },
    {
      '<leader>to',
      "<cmd>lua require('neotest').output.open({enter = true, auto_close = true})<cr>",
      desc = 'Open output test',
    },
    {
      '<leader>tp',
      "<cmd>lua require('neotest').output_panel.toggle()<cr>",
      desc = 'Output test panel',
    },
    {
      '<leader>tt',
      function()
        require('neotest').summary.open()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Neotest toggle',
    },
  }
end

return M
