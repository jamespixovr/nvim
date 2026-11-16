return {
  {
    'nvim-lualine/lualine.nvim',
    event = 'UIEnter',
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = ' '
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      -- PERF: we don't need this lualine require madness 🤷
      -- from https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/ui.lua
      local lualine_require = require('lualine_require')
      lualine_require.require = require

      local status = require('plugins.ui.lualine.status')
      return {
        options = {
          theme = 'catppuccin-nvim',
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = { 'lazy', 'alpha', 'snacks_dashboard', 'NvimTree', 'toggleterm', 'neo-tree', 'codecompanion' },
            winbar = { 'lazy', 'alpha', 'toggleterm', 'NvimTree', 'Trouble', 'neo-tree', 'codecompanion', 'snacks' },
          },
          globalstatus = true,
          always_divide_middle = true,
          refresh = {
            statusline = 200,
            tabline = 1000,
            winbar = 1000,
          },
          ignore_focus = {
            'DressingInput',
            'DressingSelect',
            'lspinfo',
            'ccc-ui',
            'TelescopePrompt',
            'checkhealth',
            'noice',
            'mason',
            'qf',
            'lazy',
            'snacks',
          },
        },
        tabline = {},
        sections = {
          lualine_a = {
            status.mode(),
          },
          lualine_b = {
            status.branch(),
            status.git_diff(),
            status.diagnostics(),
          },
          lualine_c = {
            '%=',
            status.filename(),
          },
          lualine_x = {
            -- 'cc_model',
            status.ObsidianStatus(),
            status.DapStatus(),
            status.showMacroRecording(),
            status.filetype(),
            status.LazyUpdates(),
            status.Overseer(),
            -- status.treesitter(),
            {
              function()
                return ' '
              end,
              separator = { right = '' },
              padding = { left = 0, right = 0 },
            },
          },
          lualine_y = {
            status.codecompanion(),
            -- status.lsp(),
            status.LspStatus(),
          },
          lualine_z = {
            status.progress(),
            -- status.quickfixCounter(),
            -- status.datetime(),
            -- status.scrollbar(),
          },
        },
        extensions = {
          'nvim-tree',
          'trouble',
          'quickfix',
          'nvim-dap-ui',
          'toggleterm',
          'lazy',
          'mason',
          'oil',
          'fzf',
          -- status.overseer_ext,
        },
      }
    end,
    config = function(_, opts)
      require('lualine').setup(opts)
      -- Add overseer integration after lualine is set up
      vim.schedule(function()
        local ok, overseer = pcall(require, 'overseer')
        if ok then
          local lualine = require('lualine')
          local config = lualine.get_config()
          table.insert(config.sections.lualine_x, 1, {
            'overseer',
            label = '',
            colored = true,
            symbols = {
              [overseer.STATUS.FAILURE] = '✗ ',
              [overseer.STATUS.CANCELED] = '⊘ ',
              [overseer.STATUS.SUCCESS] = '✓ ',
              [overseer.STATUS.RUNNING] = '⟳ ',
            },
            unique = false,
          })
          lualine.setup(config)
        end
      end)
    end,
  },
}
