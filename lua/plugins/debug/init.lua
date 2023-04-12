return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
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
        "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
      }
    },
    { 'nvim-treesitter/nvim-treesitter' }
  },
  keys = {
    { "<leader>db", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
    { "<leader>dc", '<cmd>lua require("dap").continue()<CR>',          desc = "Continue" },
    { "<leader>dw", '<cmd>lua require("dap").run_to_cursor()<CR>',     desc = "Run to cursor" },
    { "<leader>dx", '<cmd>lua require("dap.breakpoints").clear()<cr>', desc = "Remove All Breakpoints" },
    { "<leader>dl", "<cmd>Telescope dap list_breakpoints<cr>",         desc = "Show All Breakpoints" },
    { "<leader>ds", '<cmd>lua require("dap").disconnect()<cr>',        desc = "Disconnect" },
    { "<leader>dn", '<cmd>lua require("dap").step_over()<CR>',         desc = "Step Over" },
    { "<leader>dN", '<cmd>lua require("dap").step_into()<CR>',         desc = "step Into" },
    { "<leader>do", '<cmd>lua require("dap").step_out()<CR>',          desc = "Step Out" },
    { "<leader>dp", '<cmd>lua require("dap").pause()<cr>',             desc = "Pause" },
    { "<leader>dT", "<cmd>Telescope dap configurations<cr>",           desc = "Run" },
    { "<leader>dS", '<cmd>lua require("dap").terminate()<cr>',         desc = "Terminate" },
    { "<leader>dR", '<cmd>lua require("dap").repl.open()<cr>',         desc = "Repl" },
    { "<leader>di", '<cmd>lua require("dapui").toggle()<cr>',          desc = "Dap UI" },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end
    require("plugins.debug.js-config").setup()
    require("plugins.debug.js-config").vscodeExtensions()
  end,
}


-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
