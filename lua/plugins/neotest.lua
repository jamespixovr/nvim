local settings = require('settings')

return {
  -- A library for asynchronous IO in Neovim
  { 'nvim-neotest/nvim-nio' },

  {
    'nvim-neotest/neotest',
    version = false,
    lazy = true,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
    },

		-- stylua: ignore start
    keys = {
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>", desc = "Run nearest test", },
      { "<leader>tN", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Run All Test Files", },
      { "]e", function() require("neotest").jump.next() end,  desc = "Next Test", },
      { "[e", function() require("neotest").jump.prev() end,  desc = "Previous Test", },
      { "<leader>tl", function() require('neotest').run.run_last() end , desc = "Run last test", },
      { "<leader>tf", function() require('neotest').run.run(vim.fn.expand("%")) end , desc = "Run test file", },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug test", },
      { "<leader>tD", "w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", desc = "Debug File", },
      { "<leader>ta", "<cmd>lua require('neotest').run.attach()<cr>", desc = "Attach test", },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary", },
      { "<leader>tx", "<cmd>lua require('neotest').stop()<cr>", desc = "Stop test", },
      { "<leader>to", function() require('neotest').output.open({enter = true, auto_close = true}) end, desc = "Open output test", },
      { "<leader>tO", function() require('neotest').output_panel.toggle() end, desc = "Output test panel", },
      { "<leader>tt", function() require("neotest").summary.open() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Neotest toggle", },
    },

    -- stylua: ignore end
    opts = function()
      return {
        -- log_level = vim.log.levels.DEBUG,
        status = { virtual_text = true },
        output = { open_on_run = true },
        floating = {
          border = 'rounded',
          max_height = 0.85,
          max_width = 0.85,
          options = {},
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
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        summary = {
          open = 'botright vsplit | vertical resize 60',
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = 'a',
            expand = { '<Space>', '<2-LeftMouse>' },
            expand_all = 'L',
            jumpto = '<CR>',
            output = 'o',
            run = 'r',
            short = 'p',
            stop = 'u',
          },
        },
        adapters = {},
        icons = {
          passed = settings.icons.testing.Success,
          running = '',
          failed = settings.icons.testing.Failed,
          unknown = '',
          expanded = '',
          child_prefix = '',
          child_indent = '',
          final_child_prefix = '',
          non_collapsible = '',
          collapsed = '',

          running_animated = vim.tbl_map(function(s)
            return s .. ' '
          end, { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }),
        },
        consumers = {
          overseer = require('neotest.consumers.overseer'),
        },
        overseer = {
          enabled = true,
          force_default = true,
        },
      }
    end,
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == 'number' then
            if type(config) == 'string' then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == 'table' and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error('Adapter ' .. name .. ' does not support setup')
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end
      require('neotest').setup(opts)
    end,
  },
}
