local settings = require("settings")
return {
  {
    "nvim-neotest/neotest",
    event = 'VeryLazy',
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      { "andythigpen/nvim-coverage", config = true },
      {
        "stevearc/overseer.nvim",
        config = function()
          require("overseer").setup()
        end,
      },
    },
    keys = {
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>",                     desc = "Run nearest test" },
      { "<leader>tl", "<cmd>lua require('neotest').run.run_last()<cr>",                desc = "Run last test" },
      { "<leader>tf", '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>',   desc = "Run test file" },
      { "<leader>td", function() require('neotest').run.run({ strategy = 'dap' }) end, desc = "Debug test" },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>",                  desc = "Attach test" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>",              desc = "Test Summary Toggle" },
      { "<leader>tx", "<cmd>lua require('neotest').stop()<cr>",                        desc = "Stop test" },
      { "<leader>to", "<cmd>lua require('neotest').output.open({enter = true})<cr>",   desc = "Open output test" },
      { "<leader>tp", "<cmd>lua require('neotest').output_panel.toggle()<cr>",         desc = "Output test panel" },
      {
        '<leader>rt',
        function()
          require('neotest').summary.open()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = 'Neotest toggle',
      },
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
        status = { virtual_text = true },
        output = { open_on_run = true },
        floating = {
          border = "rounded",
          max_height = 0.85,
          max_width = 0.85,
          options = {}
        },
        quickfix = {
          enabled = false,
          -- open = function()
          --   vim.cmd("Trouble quickfix")
          -- end,
        },
        output_panel = {
          open = 'rightbelow vsplit | resize 30',
        },
        summary = {
          open = "botright vsplit | vertical resize 60"
        },
        adapters = {
          require("neotest-go")({
            args = { "-count=1", "-timeout=60s", "-race", "-cover" },
            experimental = {
              test_table = true,
            },
          }),
          require("neotest-jest")({
            jestCommand = "pnpm test -- ",
            -- jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(_path)
              return vim.fn.getcwd()
            end,
          }),
          require("neotest-rust"),
        },
        icons = {
          failed = settings.icons.testing.Failed,
          passed = settings.icons.testing.Success,
          running = settings.icons.testing.Running,
          running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opt)
      require("neotest").setup(opt)
    end,
  }
}
