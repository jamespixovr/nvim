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
  }
}
