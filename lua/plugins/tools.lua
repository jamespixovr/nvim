return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
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
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>hs", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Fla[s][h]" },
      { "<leader>hS", mode = { "n", "o", "x" }, function() require("flash").treesitter() end,        desc = "Flas[h] Tree[s]itter" },
      { "<leader>hr", mode = "o",               function() require("flash").remote() end,            desc = "[R]emote Flas[h]" },
      { "<leader>hT", mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flas[h] [T]reesitter Search" },
      -- { "<leader>hf", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle [F]las[h] Search" },
    },
  },

  -- A library for asynchronous IO in Neovim
  { "nvim-neotest/nvim-nio" },
  -- - HTTP client
  {
    "jellydn/hurl.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "hurl" },
    opts = {
      debug = false,
      show_notification = false,
      mode = "split",
      formatters = {
        json = { "jq" },
        html = {
          "prettier",
          "--parser",
          "html",
        },
      },
    },
    keys = {
      { "<leader>A", "<cmd>HurlRunner<CR>", desc = "Run All requests" },
      { "<leader>a", "<cmd>HurlRunnerAt<CR>", desc = "Run Api request" },
      { "<leader>te", "<cmd>HurlRunnerToEntry<CR>", desc = "Run Api request to entry" },
      { "<leader>tm", "<cmd>HurlToggleMode<CR>", desc = "Hurl Toggle Mode" },
      { "<leader>tv", "<cmd>HurlVerbose<CR>", desc = "Run Api in verbose mode" },
      { "<leader>h", ":HurlRunner<CR>", desc = "Hurl Runner", mode = "v" },
    },
  },
  -----------------------------------
  -- Send buffers into early retirement by automatically closing them after x minutes of inactivity.
  {
    "chrisgrieser/nvim-early-retirement",
    config = true,
    event = "VeryLazy",
  },

  {
    "kevinhwang91/nvim-bqf", -- Better quickfix window,
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      func_map = {
        open = "<cr>",
        openc = "o",
        vsplit = "v",
        split = "s",
        fzffilter = "f",
        pscrollup = "<C-u>",
        pscrolldown = "<C-d>",
        ptogglemode = "F",
        filter = "n",
        filterr = "N",
      },
    },
    dependencies = {
      "junegunn/fzf",
      build = function()
        vim.fn["fzf#install"]()
      end,
    },
  },

  {
    "tpope/vim-fugitive",
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPost", "BufWritePre" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>gb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "]g", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
      { "[g", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
    },
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
        delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        changedelete = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
      },
      numhl = false,
      linehl = false,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      diff_opts = { internal = true },
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <abbrev_sha> - <summary>",
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
    opts = {
      integrations = {
        diffview = true,
      },
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    },
    config = true,
  },
  {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>fn", ":FzfLua<cr>", desc = "Fzf Lua" },
    },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
  ---- pixo related plugins ----
  {
    "jamespixovr/pixovr.nvim",
    event = "VeryLazy",
    cmd = { "Pixovr" },
    dependencies = {
      "stevearc/overseer.nvim",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>pg", "<cmd>Pixovr generate<cr>", desc = "System [P]ixovr [G]enerate Ginkgo" },
      { "<leader>tc", "<cmd>Pixovr local<cr>", desc = "System [T]est Lo[c]al" },
      { "<leader>ty", "<cmd>Pixovr lifecycle<cr>", desc = "System [T]est [L]ifecycle" },
      { "<leader>pb", "<cmd>Pixovr bootstrap<cr>", desc = "Pixovr [B]ootstrap Ginkgo" },
    },
    config = true,
  },
}
