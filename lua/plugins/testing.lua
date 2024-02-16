local settings = require("settings")
return {
  --  COMPILER ----------------------------------------------------------------
  --  compiler.nvim [compiler]
  --  https://github.com/Zeioth/compiler.nvim
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
    keys = {
      { "<leader>lo", "<cmd>CompilerOpen<cr>", desc = "Compi[l]er [o]pen" },
      { "<leader>lr", "<cmd>CompilerRedo<cr>", desc = "Compi[l]er [r]edo" },
    },

  },

  --  overseer [task runner]
  --  https://github.com/stevearc/overseer.nvim
  {
    "stevearc/overseer.nvim",
    event = 'VeryLazy',
    cmd = {
      "Grep",
      "Make",
      "OverseerDebugParser",
      "OverseerInfo",
      "OverseerOpen",
      "OverseerRun",
      "OverseerRunCmd",
      "OverseerToggle",
      "CompilerOpen",
      "CompilerToggleResults"
    },
    keys = {
      { "<leader>oR", "<cmd>OverseerRunCmd<cr>",       desc = "Run Command" },
      { "<leader>oa", "<cmd>OverseerTaskAction<cr>",   desc = "Task Action" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>",        desc = "Build" },
      { "<leader>oc", "<cmd>OverseerClose<cr>",        desc = "Close" },
      { "<leader>od", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
      { "<leader>ol", "<cmd>OverseerLoadBundle<cr>",   desc = "Load Bundle" },
      { "<leader>oo", "<cmd>OverseerOpen<cr>",         desc = "Open" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>",  desc = "Quick Action" },
      { "<leader>or", "<cmd>OverseerRun<cr>",          desc = "Run" },
      { "<leader>os", "<cmd>OverseerSaveBundle<cr>",   desc = "Save Bundle" },
      { "<leader>ot", "<cmd>OverseerToggle<cr>",       desc = "Toggle" },
    },
    opts = {
      dap = false,
      strategy = { "jobstart" },
      task_launcher = {
        bindings = {
          n = {
            ["<leader>c"] = "Cancel",
          },
        },
      },
      task_list = {
        direction = "bottom",
        min_height = 25,
        max_height = 25,
        default_detail = 1,
        bindings = {
          -- ["<Tab>"] = "IncreaseDetail",
          -- ["<S-Tab>"] = "DecreaseDetail",
          ["gh"] = "IncreaseAllDetail",
          ["gl"] = "DecreaseAllDetail",
        },
      },
      form = {
        border = "solid",
        win_opts = {
          winblend = 0,
          winhl = "FloatBorder:NormalFloat",
        },
      },
      component_aliases = {
        default = {
          { "display_duration",   detail_level = 2 },
          "on_result_notify",
          "on_exit_set_status",
          { "on_complete_notify", system = "unfocused" },
          "on_complete_dispose",
        },
        default_neotest = {
          "unique",
          "on_output_summarize",
          "on_exit_set_status",
          "on_complete_dispose",
        },
      },
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      vim.api.nvim_create_user_command("OverseerDebugParser", 'lua require("overseer").debug_parser()', {})

      vim.api.nvim_create_user_command("Grep", function(params)
        local args = vim.fn.expandcmd(params.args)
        -- Insert args at the '$*' in the grepprg
        local cmd, num_subs = vim.o.grepprg:gsub("%$%*", args)
        if num_subs == 0 then
          cmd = cmd .. " " .. args
        end
        local cwd
        local has_oil, oil = pcall(require, "oil")
        if has_oil then
          cwd = oil.get_current_dir()
        end
        local task = overseer.new_task({
          cmd = cmd,
          cwd = cwd,
          name = "grep " .. args,
          components = {
            {
              "on_output_quickfix",
              errorformat = vim.o.grepformat,
              open = not params.bang,
              open_height = 8,
              items_only = true,
            },
            -- We don't care to keep this around as long as most tasks
            { "on_complete_dispose", timeout = 30 },
            "default",
          },
        })
        task:start()
      end, { nargs = "*", bang = true, bar = true, complete = "file" })

      vim.api.nvim_create_user_command("Make", function(params)
        -- Insert args at the '$*' in the makeprg
        local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
        if num_subs == 0 then
          cmd = cmd .. " " .. params.args
        end
        local task = require("overseer").new_task({
          cmd = vim.fn.expandcmd(cmd),
          components = {
            { "on_output_quickfix", open = not params.bang, open_height = 8 },
            "unique",
            "default",
          },
        })
        task:start()
      end, {
        desc = "Run your makeprg as an Overseer task",
        nargs = "*",
        bang = true,
      })
    end
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
    requires = { "nvim-lua/plenary.nvim" },
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
