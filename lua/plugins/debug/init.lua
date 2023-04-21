local icons = {
  dap = {
    Stopped = { " ", "DiagnosticWarn", "DapStoppedLine" }, -- 
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = "",
  },
}
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
    { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
    { "<leader>de", "<cmd>lua require('dapui').eval()<cr>",                               desc = "Evaluate" },
    { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                     desc = "Hover Variables" },
    { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>",                   desc = "Preview" },
    { "<leader>dq", "<cmd>lua require('dap').close()<cr>",                                desc = "Quit" },
    { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>",                        desc = "Run to Cursor" },
    { "<leader>dL", "<cmd>lua require('dap').run_last()<cr>",                             desc = "Run Last" },
  },
  config = function()
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    for name, sign in pairs(icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end
    -- require("plugins.debug.js-config").setup()
    -- require("plugins.debug.js-config").vscodeExtensions()
  end,
  dependencies = {
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    "nvim-telescope/telescope-dap.nvim",
    {
      "leoluz/nvim-dap-go",
      module = "dap-go",
      opts = {}
    },
    { 'nvim-treesitter/nvim-treesitter' },
    -- fancy UI for the debugger
    {
      "rcarriga/nvim-dap-ui",
      -- stylua: ignore
      keys = {
        { "<leader>dI", function() require("dapui").toggle({}) end, desc = "Dap UI" }
      },
      opts = {},
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")
        dapui.setup(opts)
        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    -- which key integration
    {
      "folke/which-key.nvim",
      opts = {
        defaults = {
          ["<leader>d"] = { name = "+debug" },
          ["<leader>da"] = { name = "+adapters" },
        },
      },
    },
    -- mason.nvim integration
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = "mason.nvim",
      cmd = { "DapInstall", "DapUninstall" },
      opts = {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_setup = true,
        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},
        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
        },
      },
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      -- stylua: ignore
      keys = {
        { "<leader>daL", function() require("osv").launch({ port = 8086 }) end, desc = "Adapter Lua Server" },
        { "<leader>dal", function() require("osv").run_this() end,              desc = "Adapter Lua" },
      },
      config = function()
        local dap = require("dap")
        dap.adapters.nlua = function(callback, config)
          callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        }
      end,
    },
  }
}


-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
