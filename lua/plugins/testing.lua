local settings = require("settings")
return {
  --  COMPILER ----------------------------------------------------------------
  --  compiler.nvim [compiler]
  --  https://github.com/Zeioth/compiler.nvim
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    keys = {
      { "<leader>lo", "<cmd>CompilerOpen<cr>", desc = "Compi[l]er [o]pen" },
      { "<leader>lr", "<cmd>CompilerRedo<cr>", desc = "Compi[l]er [r]edo" },
    },
    opts = function()
      vim.g.NODEJS_PACKAGE_MANAGER = "pnpm"
      return {}
    end,
  },

  --  Shows a float panel with the [code coverage]
  --  https://github.com/andythigpen/nvim-coverage
  --
  --  Your project must generate coverage/lcov.info for this to work.
  --
  --  On jest, make sure your packages.json file has this:
  --  "tests": "jest --coverage"
  --
  --  If you use other framework or language, refer to nvim-coverage docs:
  --  https://github.com/andythigpen/nvim-coverage/blob/main/doc/nvim-coverage.txt
  {
    "andythigpen/nvim-coverage",
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageLoadLcov",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    config = function() require("coverage").setup() end,
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "nvim-neotest/neotest",
    version = false,
    lazy = true,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
    },
    keys = {
      {
        "<leader>tn",
        "<cmd>lua require('neotest').run.run()<cr>",
        desc =
        "Run nearest test"
      },
      {
        "<leader>tT",
        function() require("neotest").run.run(vim.loop.cwd()) end,
        desc =
        "Run All Test Files"
      },
      {
        "<leader>tb",
        function() require("neotest").run.run(vim.api.nvim_buf_get_name(0)) end,
        mode = "n",
        desc = "Run test file"
      },
      {
        "<leader>tl",
        "<cmd>lua require('neotest').run.run_last()<cr>",
        desc =
        "Run last test"
      },
      {
        "<leader>tf",
        '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>',
        desc =
        "Run test file"
      },
      {
        "<leader>td",
        ---@diagnostic disable-next-line: missing-fields
        function() require('neotest').run.run({ strategy = 'dap' }) end,
        desc = "Debug test"
      },
      { "<leader>tD", "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File" },
      {
        "<leader>ta",
        "<cmd>lua require('neotest').run.attach()<cr>",
        desc =
        "Attach test"
      },
      {
        "<leader>ts",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle Summary"
      },
      {
        "<leader>tx",
        "<cmd>lua require('neotest').stop()<cr>",
        desc = "Stop test"
      },
      {
        "<leader>to",
        "<cmd>lua require('neotest').output.open({enter = true, auto_close = true})<cr>",
        desc =
        "Open output test"
      },
      {
        "<leader>tp",
        "<cmd>lua require('neotest').output_panel.toggle()<cr>",
        desc =
        "Output test panel"
      },
      {
        '<leader>tt',
        function()
          require('neotest').summary.open()
          require('neotest').run.run(vim.fn.expand('%'))
        end,
        desc = 'Neotest toggle',
      },
    },
    opts = function()
      return {
        -- log_level = vim.log.levels.DEBUG,
        status = { virtual_text = true },
        output = { open_on_run = true },
        floating = {
          border = "rounded",
          max_height = 0.85,
          max_width = 0.85,
          options = {}
        },
        quickfix = {
          enabled = true,
          open = false,
          -- open = function()
          --   vim.cmd("Trouble quickfix")
          -- end,
        },
        output_panel = {
          open = 'rightbelow vsplit | resize 30',
        },
        summary = {
          open = "botright vsplit | vertical resize 60",
          mappings = {
            attach = "a",
            expand = "l",
            expand_all = "L",
            jumpto = "gf",
            output = "o",
            run = "<C-r>",
            short = "p",
            stop = "u",
            next_failed = "J",
            prev_failed = "K",
          },
        },
        adapters = {},
        icons = {
          passed = settings.icons.testing.Success,
          running = "",
          failed = settings.icons.testing.Failed,
          unknown = "",
          running_animated = vim.tbl_map(function(s)
            return s .. " "
          end, { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }),
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
    config = function(_, opts)
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

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end
      require("neotest").setup(opts)
    end,
  },

}
