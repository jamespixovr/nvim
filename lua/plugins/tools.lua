return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre',
    opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" }
    }
,
  },
  -- Flash enhances the built-in search functionality by showing labels
  -- at the end of each match, letting you quickly jump to a specific
  -- location.
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>hs", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Fla[s][h]" },
      { "<leader>hS", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flas[h] Tree[s]itter" },
      { "<leader>hr", mode = "o",               function() require("flash").remote() end,            desc = "[R]emote Flas[h]" },
      { "<leader>hT", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flas[h] [T]reesitter Search" },
    },
  },

  -----------------------------------
  -- Send buffers into early retirement by automatically closing them after x minutes of inactivity.
  {
    'chrisgrieser/nvim-early-retirement',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      minimumBufferNum = 4,
      -- if a buffer has been inactive for this many minutes, close it
      retirementAgeMins = 30,
    },
  },

  {
    'kevinhwang91/nvim-bqf', -- Better quickfix window,
    ft = 'qf',
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      func_map = {
        open = '<cr>',
        openc = 'o',
        vsplit = 'v',
        split = 's',
        fzffilter = 'f',
        pscrollup = '<C-u>',
        pscrolldown = '<C-d>',
        ptogglemode = 'F',
        filter = 'n',
        filterr = 'N',
      },
    },
  },

  ---- pixo related plugins ----
  {
    'jamespixovr/pixovr.nvim',
    event = 'VeryLazy',
    cmd = { 'Pixovr' },
    dependencies = {
      'stevearc/overseer.nvim',
      'MunifTanjim/nui.nvim',
    },
    config = true,
  },
  -- e.g. for go.mod and swagger yaml
  -- https://github.com/icholy/lsplinks.nvim
  {
    'icholy/lsplinks.nvim',
    config = function()
      require('lsplinks').setup({
        highlight = true,
        hl_group = 'Underlined',
      })
    end,
  },
  {
    'rachartier/tiny-inline-diagnostic.nvim',
    enabled = false,
    event = 'VeryLazy',
    config = function()
      require('tiny-inline-diagnostic').setup({
        blend = {
          factor = 0.3,
        },
        options = {
          break_line = {
            enabled = true,
            after = 80,
          },
          multiple_diag_under_cursor = true,
          show_source = true,
        },
      })
    end,
  },
  {
    'lukas-reineke/headlines.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    opts = {
      markdown = {
        bullets = {},
      },
    }, -- or `opts = {}`
  },
}
