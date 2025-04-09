local icons = require('lib.icons')
local keymaps = require('plugins.coding.dap.keymaps')

--------------------------------------------------------------------------------------

local function dapConfig()
  vim.fn.sign_define('DapStopped', { text = icons.dap.Stopped, texthl = 'DiagnosticHint', linehl = 'DapPause' })
  vim.fn.sign_define('DapBreakpoint', { text = icons.dap.Breakpoint, texthl = 'DiagnosticInfo', linehl = 'DapBreak' })
  vim.fn.sign_define('DapBreakpointRejected', { text = icons.dap.BreakpointRejected, texthl = 'DiagnosticError' })

  -- use overseer for running preLaunchTask and postDebugTask
  require('overseer').enable_dap()

  -- require('dap.ext.vscode').load_launchjs('launch.json')
  -- require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })
  require('dap.ext.vscode').json_decode = require('overseer.json').decode

  -- AUTO-OPEN/CLOSE THE DAP-UI
  local listener = require('dap').listeners.before
  listener.attach.dapui_config = function()
    require('dapui').open()
  end
  listener.launch.dapui_config = function()
    require('dapui').open()
  end
  listener.event_terminated.dapui_config = function()
    require('dapui').close()
  end
  listener.event_exited.dapui_config = function()
    require('dapui').close()
  end

  require('plugins.coding.dap.typescript')
end

return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = keymaps.dap_keymaps(),
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = { virt_text_pos = 'eol' } },
    },

    config = dapConfig,
  },

  { -- fancy UI for the debugger
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = { 'nvim-neotest/nvim-nio' },
    keys = keymaps.dap_ui_keymaps(),
    opts = {
      icons = {
        expanded = icons.ui.TriangleShortArrowDown,
        current_frame = icons.ui.CurrentFrame,
        collapsed = icons.ui.TriangleShortArrowRight,
      },
      layouts = {
        {
          elements = {
            { id = 'repl', size = 0.4 },
            { id = 'scopes', size = 0.6 },
          },
          position = 'bottom',
          size = 15,
        },
      },
      floating = {
        border = vim.g.borderStyle,
        mappings = {
          close = { 'q', '<Esc>' },
        },
      },
      render = {
        max_type_length = nil,
        indent = 2,
        max_value_lines = 100,
      },
    },
  },

  { -- mason.nvim integration
    'jay-babu/mason-nvim-dap.nvim',
    event = 'VeryLazy',
    dependencies = 'mason.nvim',
    cmd = { 'DapInstall', 'DapUninstall' },
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
    'leoluz/nvim-dap-go',
    event = 'VeryLazy',
    config = function()
      require('dap-go').setup({
        dap_configurations = {
          {
            type = 'go',
            name = 'Debug (Main) Package',
            request = 'launch',
            program = 'main.go',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'go',
            name = "Delve: debug opened file's cmd/cli",
            request = 'launch',
            cwd = '${fileDirname}', -- FIXME: should work from repo root
            program = './${relativeFileDirname}',
            args = {},
          },
          {
            type = 'go',
            name = 'Delve: debug test (manually enter test name)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
            args = function()
              local testname = vim.fn.input('Test name (^regexp$ ok): ')
              return { '-test.run', testname }
            end,
          },
        },
      })
    end,
  },
  -- [persistent-breakpoints.nvim] - Store breakpoints location on disk and load them on buffer open event.
  -- See: `:h persistent-breakpoints.nvim`
  -- link: https://github.com/Weissle/persistent-breakpoints.nvim
  {
    'Weissle/persistent-breakpoints.nvim',
    branch = 'main',
    keys = keymaps.persistent_keymaps(),
    opts = {
      save_dir = vim.fn.stdpath('cache') .. '/nvim_breakpoints',
      load_breakpoints_event = { 'BufReadPost' },
      perf_record = false,
      on_load_breakpoint = nil,
    },
  },
}
