return {
  "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight

  -----------------------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<Leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undo Tree" },
    },
  },

  -----------------------------------------------------------------------------

  -- references
  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = require("config.keymaps").illuminate_keymaps(),
  },

  -- search/replace in multiple files
  {
    "nvim-pack/nvim-spectre",
    event = "VeryLazy",
    cmd = "Spectre",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- toggle terminal
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    keys = require("config.keymaps").terminal_keymaps(),
    opts = {
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = "horizontal",
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
  },

  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        names = false,
      },
      filetypes = {
        "css",
        "scss",
        eruby = { mode = "foreground" },
        html = { mode = "foreground" },
        "lua",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        yaml = { mode = "background" },
        json = { mode = "background" },
      },
    },
  },
  {
    -- display line numbers while going to a line with `:`
    "nacro90/numb.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("numb").setup({
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
      })
    end,
  },
}
