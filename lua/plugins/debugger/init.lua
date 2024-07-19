local icons = require("settings").icons.dap

--------------------------------------------------------------------------------------

local function dapConfig()
  vim.fn.sign_define("DapStopped", { text = icons.Stopped, texthl = "DiagnosticHint", linehl = "DapPause" })
  vim.fn.sign_define("DapBreakpoint", { text = icons.Breakpoint, texthl = "DiagnosticInfo", linehl = "DapBreak" })
  vim.fn.sign_define("DapBreakpointRejected", { text = icons.BreakpointRejected, texthl = "DiagnosticError" })

  -- use overseer for running preLaunchTask and postDebugTask
  require("overseer").patch_dap(true)
  require("dap.ext.vscode").json_decode = require("overseer.json").decode

  require("dap.ext.vscode").load_launchjs("launch.json")

  -- AUTO-OPEN/CLOSE THE DAP-UI
  local listener = require("dap").listeners.before
  listener.attach.dapui_config = function()
    require("dapui").open()
  end
  listener.launch.dapui_config = function()
    require("dapui").open()
  end
  listener.event_terminated.dapui_config = function()
    require("dapui").close()
  end
  listener.event_exited.dapui_config = function()
    require("dapui").close()
  end

  require("plugins.debugger.typescript")
end

return {
  --  DEBUGGER ----------------------------------------------------------------
  --  Debugger alternative to vim-inspector [debugger]
  --  https://github.com/mfussenegger/nvim-dap
  --  Here we configure the adapter+config of every debugger.
  --  Debuggers don't have system dependencies, you just install them with mason.
  --  We currently ship most of them with nvim.
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    keys = require("config.keymaps").dap_keymaps(),

    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = "eol" } },
    },

    config = dapConfig,
  },

  { -- fancy UI for the debugger
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = require("config.keymaps").dap_ui_keymaps(),
    opts = {
      icons = { expanded = "▾", collapsed = "▸" },
      -- floating = { border = 'rounded' },
      layouts = {
        {
          elements = {
            -- { id = 'stacks',      size = 0.30 },
            -- { id = 'breakpoints', size = 0.20 },
            { id = "scopes", size = 0.50 },
            { id = "watches", size = 0.50 },
          },
          position = "right",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
      floating = {
        border = vim.g.borderStyle,
        -- max_height = 0.5,
        -- max_width = 0.9,
        -- border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      render = {
        max_type_length = nil,
      },
    },
  },

  { -- mason.nvim integration
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
  --  Debugging with go debugger
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup({
        dap_configurations = {
          {
            type = "go",
            name = "Debug (Main) Package",
            request = "launch",
            program = "main.go",
            cwd = "${workspaceFolder}",
          },
        },
      })
    end,
  },
}

-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
-- https://github.com/NormalNvim/NormalNvim/blob/main/lua/plugins/4-dev.lua
