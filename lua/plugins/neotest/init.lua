local settings = require('settings')

return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-neotest/neotest-jest',
      { 'nvim-neotest/nvim-nio' },
    },
    keys = require('plugins.neotest.keymaps').keymaps(),
    opts = {
      -- consumers = {
      --   overseer = require('neotest.consumers.overseer'),
      -- },
      log_level = vim.log.levels.ERROR,
      status = { virtual_text = true, signs = true },
      output = { open_on_run = false },
      floating = {
        border = 'rounded',
        max_height = 0.90,
        max_width = 0.90,
      },
      quickfix = {
        enabled = true,
        open = false,
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
          expand_all = 'L',
          jumpto = '<CR>',
          output = 'o',
          run = 'r',
          short = 'p',
          stop = 'u',
        },
      },

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
    },
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
