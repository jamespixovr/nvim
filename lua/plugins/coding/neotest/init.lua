local ok, trouble = pcall(require, 'trouble')

local icons = require('helpers.icons')

local tags = '-tags=wireinject,integration'

local adaptersList = {
  ['neotest-vitest'] = {
    -- vitestCommand = "pnpm vitest",
    args = { '--coverage' },
  },
  ['neotest-jest'] = {
    -- jestCommand = 'pnpm run test --',
    -- env = { CI = true },
    -- cwd = require('neotest-jest').root,
  },

  ['neotest-golang'] = {
    warn_test_name_dupes = false,
    dap_mode = 'manual',
    dap_manual_config = {
      type = 'delve',
      request = 'launch',
      mode = 'test',
    },
    go_list_args = { tags },
    go_test_args = {
      '-v',
      '-count=1',
      '-race',
      '-coverprofile=' .. vim.fn.getcwd() .. '/coverage.out',
      -- "-p=1",
      '-parallel=1',
      tags,
    },
    runner = 'gotestsum',
    gotestsum_args = { '--format=standard-verbose' },
    -- testify_enabled = true,
    -- sanitize_output = true,
    -- log_level = vim.log.levels.TRACE,

    -- experimental
    dev_notifications = true,
  },
  ['neotest-python'] = {
    runner = 'pytest',
    -- TODO: write coverage...
    args = { '--log-level', 'INFO', '--color', 'yes', '-vv', '-s' },
    dap = { justMyCode = false },
  },
}

return {
  {
    'nvim-neotest/neotest',
    lazy = true,
    event = 'VeryLazy',
    version = '*',
    dependencies = {
      'nvim-neotest/nvim-nio', -- Required dependency
      'nvim-neotest/neotest-jest', -- Jest (JavaScript/TypeScript)
      'marilari88/neotest-vitest', -- Vitest (JavaScript/TypeScript)
      'nvim-neotest/neotest-plenary', -- For testing Lua plugins
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-python',
      {
        'fredrikaverpil/neotest-golang',
        -- enabled = false,
        version = '*',
        dependencies = {
          -- 'leoluz/nvim-dap-go',
          'uga-rosa/utf8.nvim', -- required for sanitization feature
        },
      },
    },
    keys = require('plugins.coding.neotest.keymaps').keymaps(),
    opts = function()
      return {
        consumers = {
          overseer = require('neotest.consumers.overseer'),
          -- from https://github.com/seblyng/dotfiles/blob/master/nvim/lua/config/neotest.lua
          seblyng_run = function(client)
            client.listeners.starting = function()
              handle = require('fidget.progress').handle.create({
                title = 'Finding tests',
                message = 'In progress...',
                lsp_client = {
                  name = 'Neotest',
                },
              })
            end
            return {}
          end,
          seblyng_results = function(client)
            client.listeners.started = function()
              if handle then
                handle.message = 'Completed'
                handle:finish()
              end
            end
            return {}
          end,
        },
        log_level = vim.log.levels.ERROR,
        status = { enabled = true, virtual_text = true, signs = true },
        signs = {
          -- Customize signs used by Neotest
          passed = { text = '✓', hl = 'NeotestPassed' },
          failed = { text = '✗', hl = 'NeotestFailed' },
          skipped = { text = '»', hl = 'NeotestSkipped' },
          running = { text = '', hl = 'NeotestRunning' },
          unknown = { text = '?', hl = 'NeotestUnknown' },
        },
        output = { enabled = true, open_on_run = false },
        discovery = { enabled = false }, -- recommend by neotest-jest
        diagnostic = { enabled = true },
        floating = {
          border = 'rounded',
          max_height = 0.90,
          max_width = 0.90,
        },
        quickfix = {
          enabled = false,
          open = function()
            if not ok then
              vim.cmd('copen')
              return
            end
            trouble.open({ mode = 'quickfix', focus = false })
          end,
        },
        output_panel = {
          open = 'rightbelow vsplit | resize 40',
        },
        strategies = {
          integrated = {
            width = 180,
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
            expand_all = '<tab>',
            jumpto = { 'i', '<cr>' },
            mark = 'm',
            next_failed = 'J',
            output = 'o',
            prev_failed = 'K',
            run = 'r',
            debug = 'd',
            run_marked = 'R',
            debug_marked = 'D',
            short = 'O',
            stop = 's',
            target = 't',
            clear_marked = 'M',
            clear_target = 'T',
          },
        },

        icons = {
          passed = icons.testing.Success,
          running = '',
          failed = icons.testing.Failed,
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
        adapters = adaptersList,
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

      if ok then
        opts.consumers = opts.consumers or {}
        -- Refresh and auto close trouble after running tests
        ---@type neotest.Consumer
        opts.consumers.trouble = function(client)
          client.listeners.results = function(adapter_id, results, partial)
            if partial then
              return
            end
            local tree = assert(client:get_position(nil, { adapter = adapter_id }))

            local failed = 0
            for pos_id, result in pairs(results) do
              if result.status == 'failed' and tree:get_key(pos_id) then
                failed = failed + 1
              end
            end
            vim.schedule(function()
              if trouble.is_open() then
                trouble.refresh()
                if failed == 0 then
                  trouble.close()
                end
              end
            end)
            return {}
          end
        end
      end

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

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neotest-*',
        callback = function(opt)
          for _, lhs in pairs({ 'q', '<esc>' }) do
            vim.keymap.set('n', lhs, function()
              vim.cmd('quit')
            end, { buffer = opt.buf })
          end
        end,
      })

      -- Set up the autocommand for NeotestOutput filetype
      -- Scroll to the bottom of the output panel
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'neotest-output-panel',
        group = vim.api.nvim_create_augroup('neotest-scroll', { clear = true }),
        callback = function()
          vim.cmd('norm G')
        end,
      })
    end,
  },
}
-- check this https://github.com/sudo-tee/dots/blob/main/apps/nvim/config/lua/custom/plugins/neotest.lua
