return {
  {
    "nvim-neotest/neotest",
    event = "BufEnter",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
    },
    keys = {
      { "<leader>rn", "<cmd>lua require('neotest').run.run()<cr>",                   desc = "Run nearest test" },
      { "<leader>rl", "<cmd>lua require('neotest').run.run_last()<cr>",              desc = "Run last test" },
      { "<leader>rf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>', desc = "Run test file" },
      { "<leader>rd", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", desc = "Debug test" },
      { "<leader>ra", "<cmd>lua require('neotest').run.attach()<cr>",                desc = "Attach test" },
      { "<leader>rs", "<cmd>lua require('neotest').summary.toggle()<cr>",            desc = "Test Summary Toggle" },
      { "<leader>rx", "<cmd>lua require('neotest').stop()<cr>",                      desc = "Stop test" },
      { "<leader>ro", "<cmd>lua require('neotest').output.open({enter = true})<cr>", desc = "Open output test" },
      { "<leader>rp", "<cmd>lua require('neotest').output_panel.toggle()<cr>",       desc = "Output test panel" },
    },
    init = function()
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
    end,
    opts = function()
      return {
        quickfix = {
          enabled = true,
          open = false,
        },
        output_panel = {
          open = 'rightbelow vsplit | resize 30',
        },
        summary = {
          open = "botright vsplit | vertical resize 60"
        },
        adapters = {
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" }
          }),
          require("neotest-jest")({
            -- jestCommand = "pnpm test -- --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
          }),
          require("neotest-rust"),
        },
        icons = {
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        },
      }
    end,
    config = function(_, opt)
      require("neotest").setup(opt)
    end,
  },
  -- check this out https://github.com/mawkler/nvim/blob/master/lua/configs/dap.lua
  -- https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/debugger.lua
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", config = true },
      { "rcarriga/nvim-dap-ui",            config = true },
      "nvim-telescope/telescope-dap.nvim",
      { "leoluz/nvim-dap-go",                module = "dap-go" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
    keys = {
      { "<leader>dc",  '<cmd>lua require("dap").continue()<CR>',          desc = "Continue" },
      { "<leader>dbr", '<cmd>lua require("dap.breakpoints").clear()<cr>', desc = "Remove All Breakpoints" },
      { "<leader>dbs", "<cmd>Telescope dap list_breakpoints<cr>",         desc = "Show All Breakpoints" },
      { "<leader>dbt", '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = "Toggle Breakpoint" },
      { "<leader>dc",  '<cmd>lua require("dap").step_over()<CR>',         desc = "Step Over" },
      { "<leader>di",  '<cmd>lua require("dap").step_into()<CR>',         desc = "step Into" },
      { "<leader>do",  '<cmd>lua require("dap").step_out()<CR>',          desc = "Step Out" },
      { "<leader>dp",  '<cmd>lua require("dap").pause()<cr>',             desc = "Pause" },
      { "<leader>dr",  "<cmd>Telescope dap configurations<cr>",           desc = "Run" },
      { "<leader>dx",  '<cmd>lua require("dap").terminate()<cr>',         desc = "Terminate" },
      { "<leader>dvr", '<cmd>lua require("dap").repl.open()<cr>',         desc = "Repl" },
      { "<leader>du",  '<cmd>lua require("dapui").toggle()<cr>',          desc = "Dap UI" },
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
    end,
  },

  {
    "leoluz/nvim-dap-go",
    lazy = true,
    config = function()
      require("dap-go").setup()
    end,
  },

  {
    "mxsdev/nvim-dap-vscode-js",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        node_path = 'node',
        debugger_path = os.getenv('HOME') .. '/.local/share/nvim/mason/packages/js-debug-adapter',
        adapters = { 'pwa-node' }
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require 'dap.utils'.pick_process,
            cwd = "${workspaceFolder}",
          },
          {
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            }
          }
        }
      end
    end
  },
}
