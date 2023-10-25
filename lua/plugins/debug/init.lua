local nodeDapConfig = require("plugins.debug.js-config").nodeDapConfig
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
    {
      "<leader>db",
      function() require("dap").toggle_breakpoint() end,
      desc = "Toggle Breakpoint"
    },
    {
      "<leader>dc",
      function() require("dap").continue() end,
      desc = "Continue"
    },
    {
      "<leader>dC",
      function() require("dap").run_to_cursor() end,
      desc = "Run to Cursor"
    },
    { "<leader>ds", function() require("dap").continue() end, desc = "Start" },
    {
      "<leader>dg",
      function() require("dap").goto_() end,
      desc = "Go to line (no execute)"
    },
    {
      "<leader>dB",
      function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
      desc = "Breakpoint Condition"
    },
    { "<leader>dj", function() require("dap").down() end,     desc = "Down" },
    {
      "<leader>dw",
      function() require("dap.ui.widgets").hover() end,
      desc = "Widgets"
    },
    {
      "<leader>dl",
      "<cmd>Telescope dap list_breakpoints<cr>",
      desc = "Show All Breakpoints"
    },
    { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
    { "<leader>dO", "<cmd>lua require('dap').step_out()<CR>",                             desc = "Step Out" },
    { "<leader>dP", "<cmd>lua require('dapui').float_element()<cr>",                      desc = "Float Element" },
    { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>",                        desc = "Run to Cursor" },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end,                    desc = "Scopes", },
    { "<leader>dT", "<cmd>Telescope dap configurations<cr>",                              desc = "Configurations" },
    { "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>",                           desc = "Disconnect" },
    { "<leader>dg", function() require("dap").session() end,                              desc = "Get Session", },
    { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>",                     desc = "Hover Variables" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end,                     desc = "Hover Variables", },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>",                            desc = "Step Into" },
    { "<leader>dl", function() require("dap").run_last() end,                             desc = "Run Last" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<CR>",                            desc = "Step Over" },
    { "<leader>dp", "<cmd>lua require('dap').pause()<cr>",                                desc = "Pause" },
    { "<leader>dq", function() require("dap").close() end,                                desc = "Quit", },
    { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>",                            desc = "Toggle REPL" },
    { "<leader>dt", function() require("dap").toggle_breakpoint() end,                    desc = "Terminate" },
    { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>",                   desc = "Preview" },
    { "<leader>dx", "<cmd>lua require('dap').terminate()<cr>",                            desc = "Terminate" },
  },

  dependencies = {
    { "theHamsta/nvim-dap-virtual-text", opts = { virt_text_pos = 'eol' }, },

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
        { "<leader>dI", function() require("dapui").toggle({}) end, desc = "Dap UI" },

        {
          "<leader>de",
          function()
            -- Calling this twice to open and jump into the window.
            require('dapui').eval()
            require('dapui').eval()
          end,
          mode = { "n", "v" },
          desc = "Evaluate expression"
        },
      },
      opts = {
        floating = { border = 'rounded' },
        layouts = {
          {
            elements = {
              { id = 'stacks',      size = 0.30 },
              { id = 'breakpoints', size = 0.20 },
              { id = 'scopes',      size = 0.50 },
            },
            position = 'left',
            size = 40,
          },
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

    -- JS/TS debugging.
    {
      "mxsdev/nvim-dap-vscode-js",
      dependencies = {
        {
          'microsoft/vscode-js-debug',
          build = 'npm i && npm run compile vsDebugServerBundle && rm -rf out && mv -f dist out',
        },
      },

    },
    -- Lua adapter.
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
  },

  config = function(_, opts)
    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    for name, sign in pairs(icons.dap) do
      sign = type(sign) == "table" and sign or { sign }
      vim.fn.sign_define(
        "Dap" .. name,
        { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
      )
    end

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

    -- Use overseer for running preLaunchTask and postDebugTask.
    require("overseer").patch_dap(true)
    require("dap.ext.vscode").json_decode = require("overseer.json").decode


    -- JS/TS configurations.
    local dap_js = require("dap-vscode-js")
    local DEBUGGER_PATH = vim.fn.stdpath("data") .. '/lazy/vscode-js-debug'
    dap_js.setup({
      debugger_path = DEBUGGER_PATH,
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
    })
    local exts = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'svelte' }
    for _, language in ipairs(exts) do
      dap.configurations[language] = nodeDapConfig(language)
    end

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
      callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
    end

    dap.configurations['lua'] = {
      {
        type = 'nlua',
        request = 'attach',
        name = 'Attach to running Neovim instance',
      },
    }

    -- Add configurations from launch.json
    require('dap.ext.vscode').load_launchjs(nil, {
      ['codelldb'] = { 'c' },
      ['pwa-node'] = { 'typescript', 'javascript' },
    })
  end,
}


-- credit
-- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
-- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
