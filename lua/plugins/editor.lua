return {
  "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    event = "User DirOpened",
    keys = {
      { "<leader>n", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" },
    },
    opts = {
      disable_netrw = true,
      hijack_cursor = true,
      filters = { dotfiles = true },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = { "fzf", "help", "git" },
      },
      diagnostics = {
        enable = true,
        icons = { hint = "", info = "", warning = "", error = "" },
      },
      actions = { open_file = { quit_on_open = true } },
      view = {
        adaptive_size = true,
        width = 40,
        signcolumn = "no",
      },
      on_attach = require("util.nvim_tree_mapping").on_attach,
      renderer = {
        indent_markers = {
          enable = true,
        },
        group_empty = true,
        highlight_git = true,
        root_folder_modifier = ":~",
        icons = {
          glyphs = { folder = { arrow_closed = "▸", arrow_open = "▾" } },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "go.mod" },
      },
    },
  },

  -- search/replace in treesitter
  {
    "cshuaimin/ssr.nvim",
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("ssr").open() end, desc = "Structural Replace", mode = { "n", "x" } },
    },
  },
  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle<cr>",                       desc = "Trouble Toggle" },
      { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
      { "gR",         "<cmd>TroubleToggle lsp_references<cr>",        desc = "LSP References (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",                              desc = "Todo Trouble" },
      { "<leader>xT", "<cmd>TodoTelescope<cr>",                            desc = "Todo Telescope" },
      { "<leader>xf", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
      { "<leader>xF", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
    },
    config = function()
      require("todo-comments").setup {}
    end
  },

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
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 300,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    -- stylua: ignore
    keys = {
      { "]]", function() require("illuminate").goto_next_reference(false) end, desc = "Next Reference", },
      { "[[", function() require("illuminate").goto_prev_reference(false) end, desc = "Prev Reference" },
    },
  },

  -- toggle terminal
  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    keys = {
      { "<c-w>", "<c-\\><c-n>",          desc = "Normal in Terminal", mode = "t" },
      { "<a-1>", "<cmd>1ToggleTerm<cr>", desc = "Toggle Term 1",      mode = { "n", "t" } },
      { "<a-2>", "<cmd>2ToggleTerm<cr>", desc = "Toggle Term 2",      mode = { "n", "t" } },
      { "<a-3>", "<cmd>3ToggleTerm<cr>", desc = "Toggle Term 3",      mode = { "n", "t" } },
      {
        "<leader>gg",
        function()
          require("toggleterm.terminal").Terminal
              :new({ cmd = "lazygit", direction = "float", id = 1000 })
              :toggle()
        end,
        desc = "Toggle lazygit",
        mode = { "n", "t" },
      },
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
  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {},
      window = {
        border = "single", -- none, single, double, shadow
      },
      disable = {
        buftypes = {},
        filetypes = { "TelescopePrompt" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        -- ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>d"] = { name = "+debugger" },
        ["<leader>f"] = { name = "+file/find/telescope" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+hardtime" },
        -- ["<leader>gh"] = { name = "+hunks" },
        ["<leader>o"] = { name = "+task runner" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>n"] = { name = "+noice" },
        -- ["<leader>u"] = { name = "+ui" },
        ["<leader>t"] = { name = "+test runner" },
        ["<leader>v"] = { name = "+venv" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },
  -- highlight colors
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        "css",
        "scss",
        "javascript",
        html = { mode = "background" },
      }, { mode = "foreground" })
    end,
  },
  {
    -- display line numbers while going to a line with `:`
    "nacro90/numb.nvim",
    keys = ":",
    config = function() require("numb").setup() end,
  },
}
