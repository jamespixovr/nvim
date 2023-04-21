return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    { "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
    { "<leader>dc", '<cmd>lua require("dap").continue()<CR>',          desc = "Start" },
    { "<leader>ds", '<cmd>lua require("dap").continue()<CR>',          desc = "Continue" },
    {
      "<leader>dC",
      "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>",
      desc = "Conditional Breakpoint"
    },
    {
      "<leader>dw",
      "<cmd>lua require('dap').run_to_cursor()<CR>",
      desc = "Run to cursor"
    },
    {
      "<leader>dl",
      "<cmd>Telescope dap list_breakpoints<cr>",
      desc = "Show All Breakpoints"
    },
    { "<leader>dx", "<cmd>lua require('dap').disconnect()<cr>",                           desc = "Disconnect" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<CR>",                            desc = "Step Over" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>",                            desc = "step Into" },
    { "<leader>du", "<cmd>lua require('dap').step_out()<CR>",                             desc = "Step Out" },
    { "<leader>dp", "<cmd>lua require('dap').pause()<cr>",                                desc = "Pause" },
    { "<leader>dT", "<cmd>Telescope dap configurations<cr>",                              desc = "Configurations" },
    { "<leader>dS", "<cmd>lua require('dap').terminate()<cr>",                            desc = "Terminate" },
    { "<leader>dR", "<cmd>lua require('dap').repl.open()<cr>",                            desc = "Repl" },
    { "<leader>dI", "<cmd>lua require('dapui').toggle()<cr>",                             desc = "Dap UI Toggle" },
    { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
    { "<leader>de", "<cmd>lua require('dapui').eval()<cr>",                               desc = "Evaluate" },
    { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                     desc = "Hover Variables" },
    { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>",                   desc = "Preview" },
    { "<leader>dq", "<cmd>lua require('dap').close()<cr>",                                desc = "Quit" },
    { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>",                        desc = "Run to Cursor" },
    { "<leader>dL", "<cmd>lua require('dap').run_last()<cr>",                             desc = "Run Last" },
  },
  config = function()
    vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'LspDiagnosticsSignHint', linehl = '', numhl = '' })
    vim.fn.sign_define(
      'DapBreakpointRejected',
      { text = '⭐️', texthl = 'LspDiagnosticsSignInformation', linehl = '', numhl = '' }
    )
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    require("plugins.debug.js-config").setup()
    require("plugins.debug.js-config").vscodeExtensions()
  end,
  dependencies = {
    { "theHamsta/nvim-dap-virtual-text", config = true },
    { "rcarriga/nvim-dap-ui",            config = true },
    "nvim-telescope/telescope-dap.nvim",
    {
      "leoluz/nvim-dap-go",
      module = "dap-go",
      config = true,
    },
    { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    { "mxsdev/nvim-dap-vscode-js" },
    {
      "microsoft/vscode-js-debug",
      build = {
        "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && rm -rf out && mv dist out"
      }
    },
    { 'nvim-treesitter/nvim-treesitter' }
  }
}


-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
