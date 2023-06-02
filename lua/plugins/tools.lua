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
  { "nvim-lua/plenary.nvim", lazy = true },
  -- {
  --   -- Code Runner / Scratchpad
  --   "metakirby5/codi.vim",
  --   cmd = { "CodiNew", "Codi", "CodiExpand" },
  -- },

  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diff View" } },
  },
  -- Git
  -- "tpope/vim-fugitive",
  -- git blame
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    init = function()
      vim.g.gitblame_enabled = 0
    end
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      diff_opts = { internal = true },
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    }
  },
  -- browse and preview json files
  -- {
  --   "gennaro-tedesco/nvim-jqx",
  --   ft = { "json", "yaml" },
  -- },

  -- http client, treesitter: http, json
  -- {
  --   "rest-nvim/rest.nvim",
  --   ft = "http",
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   -- stylua: ignore
  --   keys = {
  --     {
  --       "<leader>th",
  --       "<Plug>RestNvim",
  --       desc =
  --       "Http Request"
  --     },
  --     {
  --       "<leader>tl",
  --       "<Plug>RestNvimLast",
  --       desc =
  --       "Last Http Request"
  --     },
  --     {
  --       "<leader>tc",
  --       "<Plug>RestNvimPreview",
  --       desc =
  --       "Preview cURL command"
  --     },
  --     {
  --       "<leader>ce",
  --       function()
  --         local env = vim.fn.input("environment: ", ".env");
  --         require("rest-nvim").select_env(env);
  --       end,
  --       desc =
  --       "Switch Environment"
  --     },
  --     {
  --       "<leader>cp",
  --       function() require("rest-nvim").run(true) end,
  --       desc =
  --       "Preview Request"
  --     },
  --     {
  --       "<leader>ct",
  --       function() require("rest-nvim").run() end,
  --       desc =
  --       "Test Request"
  --     },
  --   },
  --   opts = {
  --     -- Open request results in a horizontal split
  --     result_split_horizontal = false,
  --     -- Keep the http file buffer above|left when split horizontal|vertical
  --     result_split_in_place = false,
  --     -- Skip SSL verification, useful for unknown certificates
  --     skip_ssl_verification = false,
  --     -- Highlight request on run
  --     highlight = {
  --       enabled = true,
  --       timeout = 0,
  --     },
  --     result = {
  --       -- toggle showing URL, HTTP info, headers at top the of result window
  --       show_url = true,
  --       show_http_info = true,
  --       show_headers = true,
  --       formatters = {
  --         json = "jq",
  --       },
  --     },
  --     -- Jump to request line on run
  --     jump_to_request = false,
  --     env_file = ".env",
  --     custom_dynamic_variables = {},
  --     yank_dry_run = true,
  --   },
  -- },

}
