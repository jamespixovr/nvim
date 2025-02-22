local M = {
  -- {
  --   'folke/tokyonight.nvim',
  --   enabled = false,
  --   lazy = false,
  --   priority = 1000,
  --   opts = {
  --     style = 'storm',
  --     transparent = true,
  --     styles = {
  --       sidebars = 'transparent', -- style for sidebars, see below
  --       floats = 'transparent', -- style for floating windows
  --     },
  --   },
  -- },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    lazy = false,
    priority = 1000,
    opts = {
      flavour = 'macchiato',
      transparent_background = true,
      term_colors = true,
      compile = {
        compile_path = vim.fn.stdpath('cache') .. '/catppuccin',
        suffix = '_compiled',
      },
      styles = {
        variables = { 'italic' },
        operators = { 'italic' },
      },
      color_overrides = {
        mocha = {
          base = '#000000',
          mantle = '#000000',
          crust = '#000000',
        },
      },
      integrations = {
        alpha = true,
        lsp_trouble = true,
        mini = true,
        blink_cmp = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { 'italic' },
            hints = { 'italic' },
            warnings = { 'italic' },
            information = { 'italic' },
          },
          underlines = {
            errors = { 'undercurl' },
            hints = { 'undercurl' },
            warnings = { 'undercurl' },
            information = { 'undercurl' },
          },
          inlay_hints = {
            background = true,
          },
        },
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        navic = { enabled = false, custom_bg = 'lualine' },
        mason = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        indent_blankline = {
          enabled = false,
          colored_indent_levels = true,
        },
        dashboard = true,
        bufferline = true,
        markdown = true,
        neotest = true,
        notify = true,
        noice = true,
        illuminate = true,
        telekasten = false,
        telescope = { enabled = true },
        treesitter = true,
        treesitter_context = true,
        symbols_outline = false,
        snacks = true,
        semantic_tokens = true,
        which_key = true,
      },
      custom_highlights = function(colors)
        return {
          PmenuThumb = { bg = colors.blue },
          DapUIFloatBorder = { link = 'FloatBorder' },
        }
      end,
    },
    config = function(plugin, opt)
      vim.opt.background = 'dark'
      require(plugin.name).setup(opt)
      -- vim.api.nvim_command 'colorscheme catppuccin'
      vim.cmd.colorscheme('catppuccin')
    end,
  },
}

return M
