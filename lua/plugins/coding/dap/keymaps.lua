local M = {}

M.persistent_keymaps = function()
  return {
    { '<leader>dB', '<cmd>PBSetConditionalBreakpoint<cr>', desc = 'Conditional Breakpoint [dB]' },
    { '<leader>db', '<cmd>PBToggleBreakpoint<cr>', desc = 'Toggle Breakpoint [db]' },
    { '<leader>dx', '<cmd>PBClearAllBreakpoints<cr>', desc = 'Clear all Breakpoints [dx]' },
  }
end

M.dap_keymaps = function()
  -- stylua: ignore start
  return {
    -- { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down", },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
    { "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", desc = "Step Out" },
    { "<leader>dP", "<cmd>lua require('dapui').float_element()<cr>", desc = "Float Element" },
    { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes" },
    { "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>", desc = "Disconnect" },
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session" },
    { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "Hover Variables" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Step Into" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<CR>", desc = "Step Over" },
    { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause" },
    { "<leader>dq", function() require("dap").close() end, desc = "Quit" },
    { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Toggle REPL" },
    { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>", desc = "Preview" },
    { "<leader>dx", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },
  }
end

M.dap_ui_keymaps = function()
  return {
    {
      '<leader>dI',
      function()
        require('dapui').toggle({})
      end,
      desc = 'Dap UI',
    },
    {
      '<leader>de',
      function() -- Calling this twice to open and jump into the window.
        require('dapui').eval()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Evaluate expression',
    },
    {
      '<leader>df',
      function()
        require('dapui').float_element(nil, { width = 184, height = 44, enter = true, position = 'center' })
      end,
      desc = 'Open floating DAP [df]',
    },
  }
end

return M

-- vim.keymap.set("n", "<leader>tt", function()
--             dapui.toggle({ layout = 1, reset = true })
--             dapui.toggle({ layout = 2, reset = true })
--          end)
