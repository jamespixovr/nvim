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
  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bc", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bB", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
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
    keys = {
      { "<c-w>", "<c-\\><c-n>", desc = "Normal in Terminal", mode = "t" },
      { "<a-1>", "<cmd>1ToggleTerm<cr>", desc = "Toggle Term 1", mode = { "n", "t" } },
      { "<a-2>", "<cmd>2ToggleTerm<cr>", desc = "Toggle Term 2", mode = { "n", "t" } },
      { "<a-3>", "<cmd>3ToggleTerm<cr>", desc = "Toggle Term 3", mode = { "n", "t" } },
    },
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
