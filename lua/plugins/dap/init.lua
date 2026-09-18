local icons = require('helpers.icons')

--------------------------------------------------------------------------------------

local dap_keymaps = function()
  -- stylua: ignore start
  return {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
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

local dap_ui_keymaps = function()
  -- stylua: ignore start
  return {
    { '<leader>dI', function() require('dapui').toggle({}) end, desc = 'Dap UI', },
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

local function dapConfig()
  local dap = require('dap')
  -- use overseer for running preLaunchTask and postDebugTask
  require('overseer').enable_dap()

  -- require('dap.ext.vscode').load_launchjs('launch.json')
  -- require('dap.ext.vscode').load_launchjs(nil, { node = { 'typescript', 'javascript' } })
  require('dap.ext.vscode').json_decode = require('overseer.json').decode
  --

  require('plugins.dap.utils.typescript')

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
end

return {
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    keys = dap_keymaps(),
    dependencies = {
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
      -- {
      --   'mfussenegger/nvim-dap-python',
      --   config = function(_, opts)
      --     require('dap-python').setup('uv', opts)
      --   end,
      -- },
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
      -- }
      { -- fancy UI for the debugger
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        keys = dap_ui_keymaps(),
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

          -- Enable line wrapping for REPL window
          vim.api.nvim_create_autocmd('FileType', {
            pattern = 'dapui_repl',
            callback = function()
              vim.opt_local.wrap = true
              vim.opt_local.linebreak = true
            end,
          })
        end,
      },
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
}
