local icons = require('helpers.icons')
local keymaps = require('plugins.coding.dap.keymaps')

--------------------------------------------------------------------------------------

local function dapConfig()
  local dap = require('dap')
  -- use overseer for running preLaunchTask and postDebugTask
  require('overseer').enable_dap()

  -- require('dap.ext.vscode').load_launchjs('launch.json')
  -- require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })
  require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --
  -- -- AUTO-OPEN/CLOSE THE DAP-UI
  -- local listener = require('dap').listeners.before
  -- listener.attach.dapui_config = function()
  --   require('dapui').open()
  -- end
  -- listener.launch.dapui_config = function()
  --   require('dapui').open()
  -- end
  -- listener.event_terminated.dapui_config = function()
  --   require('dapui').close()
  -- end
  -- listener.event_exited.dapui_config = function()
  --   require('dapui').close()
  -- end

  require('plugins.coding.dap.typescript')
  -- require("config.dap.cs").setup()
  --

  -- C# config
  dap.adapters.coreclr = {
    type = 'executable',
    command = vim.fn.exepath('netcoredbg'),
    args = { '--interpreter=vscode' },
  }

  dap.configurations.cs = {
    {
      type = 'coreclr',
      name = 'Launch',
      request = 'launch',
      program = function()
        local project_path = vim.fs.root(0, function(name)
          return name:match('%.csproj$') ~= nil
        end)

        if not project_path then
          vim.notify("Couldn't find the csproj path")
          return dap.ABORT
        end

        return require('dap.utils').pick_file({
          filter = string.format('Debug/.*/%s', vim.fn.fnamemodify(project_path, ':t:r')),
          path = string.format('%s/bin', project_path),
        })
      end,
    },

    {
      type = 'coreclr',
      name = 'Attach',
      request = 'attach',
      processId = function()
        return require('dap.utils').pick_process({
          filter = function(proc)
            ---@diagnostic disable-next-line: return-type-mismatch
            return proc.name:match('.*/Debug/.*') and not proc.name:find('vstest.console.dll')
          end,
        })
      end,
    },
  }

  -- Go config
  dap.adapters.delve = function(callback, config)
    if config.mode == 'remote' and config.request == 'attach' then
      callback({
        type = 'server',
        host = config.host or '127.0.0.1',
        port = config.port or '38697',
      })
    else
      callback({
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
          detached = vim.fn.has('win32') == 0,
        },
      })
    end
  end

  dap.configurations.go = {
    {
      type = 'delve',
      name = 'Debug',
      request = 'launch',
      program = function()
        return vim.fs.root(0, { { 'go.mod' }, '.git' }) or '${file}'
      end,
    },
    {
      type = 'delve',
      name = 'Attach',
      mode = 'local',
      request = 'attach',
      processId = function()
        return require('dap.utils').pick_process()
      end,
    },
    {
      type = 'delve',
      name = 'Debug test',
      request = 'launch',
      mode = 'test',
      program = '${file}',
    },
    {
      type = 'delve',
      name = 'Debug test (go.mod)',
      request = 'launch',
      mode = 'test',
      program = './${relativeFileDirname}',
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
  }
  -- vim.keymap.set('n', '<leader>tm', function()
  --   if vim.api.nvim_buf_get_option_value('filetype', { buf = 0 }) == 'java' then
  --     require('jdtls').test_nearest_method()
  --   end
  -- end)

  vim.api.nvim_create_user_command(
    'DebugRemoteProcess',
    require('plugins.coding.dap.custom-action').attach_to_remote_debugger,
    {}
  )
end

return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = keymaps.dap_keymaps(),
    dependencies = {
      { 'theHamsta/nvim-dap-virtual-text', opts = { virt_text_pos = 'eol' } },
      {
        'mfussenegger/nvim-dap-python',
        config = function(_, opts)
          require('dap-python').setup('uv', opts)
        end,
      },
      -- {
      --   'https://github.com/igorlfs/nvim-dap-view',
      --   config = function()
      --     require('dap-view').setup({
      --       auto_toggle = true,
      --       winbar = { default_section = 'scopes' },
      --       windows = { terminal = { hide = { 'coreclr' } } },
      --       expand_lines = true,
      --       force_buffers = true,
      --       icons = {
      --         expanded = icons.ui.TriangleShortArrowDown,
      --         current_frame = icons.ui.CurrentFrame,
      --         collapsed = icons.ui.TriangleShortArrowRight,
      --       },
      --     })
      --   end,
      -- },
    },
    init = function()
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })

      -- vim.fn.sign_define('DapStopped', { text = icons.dap.Stopped, texthl = 'DiagnosticHint', linehl = 'DapPause' })
      -- vim.fn.sign_define('DapBreakpointRejected', { text = icons.dap.BreakpointRejected, texthl = 'DiagnosticError' })

      --
      vim.fn.sign_define(
        'DapBreakpoint',
        { text = icons.dap.Breakpoint, texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '󰟃', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' }
      )
      vim.fn.sign_define(
        'DapLogPoint',
        { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPoint', numhl = 'DapLogPoint' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' }
      )
    end,
    config = dapConfig,
  },
  {
    'theHamsta/nvim-dap-virtual-text',
    opts = { virt_text_pos = 'eol' },
    config = function(_, opts)
      require('nvim-dap-virtual-text').setup(opts)
      vim.api.nvim_create_user_command('DapVirtualTextClear', function()
        require('nvim-dap-virtual-text.virtual_text').clear_virtual_text()
      end, {
        desc = 'Clear all the virtual text displayed by nvim-dap-virtual-text',
        force = true,
      })
    end,
  },
  { -- fancy UI for the debugger
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = { 'nvim-neotest/nvim-nio' },
    keys = keymaps.dap_ui_keymaps(),
    opts = {
      element_mappings = {
        scopes = { open = '<CR>', edit = 'e', expand = 'o', repl = 'r' },
      },
      force_buffers = true,
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
      wrap = true,
    },
    config = function(_, opts)
      local dap, dapui = require('dap'), require('dapui')
      dapui.setup(opts)

      local function close()
        dapui.close()
        require('nvim-dap-virtual-text').refresh()
      end

      -- Listen for the initialization completion event to ensure that the UI is opened only after a successful connection
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open({ reset = true })
      end

      -- Listening for disconnect events
      dap.listeners.before.disconnect['dapui_config'] = close
      dap.listeners.before.event_terminated['dapui_config'] = close
      dap.listeners.before.event_exited['dapui_config'] = close

      -- Listen for error events and close the UI if startup fails
      dap.listeners.after.event_output.dapui_config = function(_, body)
        if body.category == 'stderr' and body.output:match('Error') then
          vim.defer_fn(function()
            if not dap.session() then
              close()
            end
          end, 500)
        end
      end

      dap.listeners.on_session['dapui_config'] = function(_, new_session)
        if not new_session then
          close()
        end
      end

      -- Unified handling of all events that may affect the dap-ui layout
      local group = vim.api.nvim_create_augroup('DapUILayoutManager', { clear = true })

      -- Listening for window change events
      vim.api.nvim_create_autocmd({ 'WinClosed', 'WinNew', 'VimResized' }, {
        group = group,
        callback = function()
          if dap.session() then
            -- Use schedule to ensure execution in the next event loop
            vim.schedule(function()
              dapui.open({ reset = true })
            end)
          end
        end,
      })
    end,
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
  -- [persistent-breakpoints.nvim] - Store breakpoints location on disk and load them on buffer open event.
  -- See: `:h persistent-breakpoints.nvim`
  -- link: https://github.com/Weissle/persistent-breakpoints.nvim
  {
    'Weissle/persistent-breakpoints.nvim',
    branch = 'main',
    -- keys = keymaps.persistent_keymaps(),
    opts = {
      save_dir = vim.fn.stdpath('cache') .. '/nvim_breakpoints',
      load_breakpoints_event = { 'BufReadPost' },
      perf_record = false,
      on_load_breakpoint = nil,
    },
    config = function(_, opts)
      require('persistent-breakpoints').setup(opts)
      -- adapted from https://github.com/machichima/nary-dotfile/blob/main/nvim/.config/nvim/lua/plugins/debugging.lua
      vim.keymap.set('n', '<Leader>db', "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<cr>")
      vim.keymap.set(
        'n',
        '<Leader>dc',
        "<cmd>lua require('persistent-breakpoints.api').set_conditional_breakpoint()<cr>"
      )
      vim.keymap.set('n', '<Leader>dl', "<cmd>lua require('persistent-breakpoints.api').set_log_point()<cr>")
    end,
  },
}
