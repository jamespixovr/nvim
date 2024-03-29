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
  },

  --- HTTP client
  -- {
  --   "rest-nvim/rest.nvim",
  --   ft = "http",
  --   dependencies = { { "nvim-lua/plenary.nvim" } },
  --   config = function()
  --     require("rest-nvim").setup({})
  --   end
  --   --   map("n", ",x", "<Plug>RestNvim", { desc = "execute request" })
  --   -- map("n", ",p", "<Plug>RestNvimPreview", { desc = "preview curl" })
  --   -- map("n", ",l", "<Plug>RestNvimLast", { desc = "repeat last request" })
  -- },
  --

  -- Send buffers into early retirement by automatically closing them after x minutes of inactivity.
  -- {
  --   "chrisgrieser/nvim-early-retirement",
  --   config = true,
  --   event = "VeryLazy",
  -- },
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

  -- better diffing
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diff View" },
      { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Close Diff View" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff View File History" },
    },
    -- adopted from https://github.com/rafi/vim-config/blob/master/lua/rafi/plugins/git.lua
    opts = function()
      local actions = require('diffview.actions')
      vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
        group = vim.api.nvim_create_augroup('rafi_diffview', {}),
        pattern = 'diffview:///panels/*',
        callback = function()
          vim.opt_local.cursorline = true
          vim.opt_local.winhighlight = 'CursorLine:WildMenu'
        end,
      })

      return {
        enhanced_diff_hl = true, -- See ':h diffview-config-enhanced_diff_hl'
        keymaps = {
          view = {
            { 'n', 'q',              '<cmd>DiffviewClose<CR>' },
            { 'n', '<Tab>',          actions.select_next_entry },
            { 'n', '<S-Tab>',        actions.select_prev_entry },
            { 'n', '<LocalLeader>a', actions.focus_files },
            { 'n', '<LocalLeader>e', actions.toggle_files },
          },
          file_panel = {
            { 'n', 'q',     '<cmd>DiffviewClose<CR>' },
            { 'n', 'h',     actions.prev_entry },
            { 'n', 'o',     actions.focus_entry },
            { 'n', 'gf',    actions.goto_file },
            { 'n', 'sg',    actions.goto_file_split },
            { 'n', 'st',    actions.goto_file_tab },
            { 'n', '<C-r>', actions.refresh_files },
            { 'n', ';e',    actions.toggle_files },
          },
          file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>' },
            { 'n', 'o', actions.focus_entry },
            { 'n', 'O', actions.options },
          },
        },
      }
    end,
  },
  -- Git
  -- check this also https://github.com/FabijanZulj/blame.nvim
  -- {
  --   "f-person/git-blame.nvim",
  --   event = "BufReadPre",
  --   config = function()
  --     require('gitblame').setup {
  --       enabled = false,
  --     }
  --   end
  -- },

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
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",              desc = "Preview Hunk" },
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
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
        virt_text_priority = 100,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <abbrev_sha> - <summary>',
    }
  },
}
