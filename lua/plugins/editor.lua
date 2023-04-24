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
      { "<leader>sR", function() require("ssr").open() end, desc = "Structural Replace", mode = { "n", "x" } },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo comment",
      },
      { "<leader>xt", "<cmd>TodoTrouble<cr>",   desc = "Todo Trouble" },
      { "<leader>xT", "<cmd>TodoTelescope<cr>", desc = "Todo Telescope" },
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
      { "<leader>cb", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>cB", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 300 },
    config = function(_, opts)
      require("illuminate").configure(opts)
      -- vim.g.Illuminate_highlightUnderCursor = 0
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
      size = 20,
      open_mapping = [[<c-\>]],
      shading_factor = 2,
      direction = "float",
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
  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
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
        -- ["<leader>f"] = { name = "+file/find" },
        -- ["<leader>g"] = { name = "+git" },
        -- ["<leader>gh"] = { name = "+hunks" },
        ["<leader>q"] = { name = "+quit/session" },
        -- ["<leader>s"] = { name = "+search" },
        ["<leader>sn"] = { name = "+noice" },
        -- ["<leader>u"] = { name = "+ui" },
        -- ["<leader>w"] = { name = "+windows" },
        ["<leader>r"] = { name = "+test runner" },
        ["<leader>d"] = { name = "+debugger" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },
  -- highlight colors
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {
      render = "background",
    },
    config = function(_, opts)
      require("nvim-highlight-colors").setup(opts)
    end,
  },
  {
    -- display line numbers while going to a line with `:`
    "nacro90/numb.nvim",
    keys = ":",
    config = function() require("numb").setup() end,
  },
}
