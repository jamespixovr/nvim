return {
  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      {
        -- fuzzy finder
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        config = function()
          require("telescope").load_extension("fzf")
        end
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        config = function()
          require("telescope").load_extension("file_browser")
        end
      },
    },
    keys = {
      { "<leader>T",  "<cmd>Telescope<cr>",                                 desc = "Open Telescope" },
      { "<leader>rr", "<cmd>Telescope resume<cr>",                          desc = "Telescope Resume" },
      { "<leader>b",  "<cmd>Telescope buffers show_all_buffers=true<cr>",   desc = "Switch Buffer" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>",                      desc = "Find Files" },
      { "<leader>fe", "<cmd>Telescope file_browser<cr>",                    desc = "Browse Files" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>",                       desc = "Find Git Files" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",                        desc = "Recent" },
      { "<leader>gc", "<cmd>Telescope git_commits<CR>",                     desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>",                      desc = "Git status" },
      { "<leader>sc", "<cmd>Telescope commands<cr>",                        desc = "Commands" },
      { "<leader>sC", "<cmd>Telescope command_history<cr>",                 desc = "Command History" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>",                       desc = "Man Pages" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>",                    desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>",       desc = "Buffer" },
      { "<leader>sl", "<cmd>Telescope symbols<cr>",                         desc = "Symbols" },
      { "<leader>sg", "<cmd>Telescope live_grep<cr>",                       desc = "Find in Files (Grep)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>",                       desc = "Help Pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>",                      desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>",                         desc = "Key Maps" },
      { "<leader>sm", "<cmd>Telescope marks<cr>",                           desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>",                     desc = "Options" },
      { "<leader>st", "<cmd>Telescope builtin include_extensions=true<cr>", desc = "Telescope" },
      { "<leader>ts", "<cmd>Telescope lsp_document_symbols<cr>",            desc = "Goto Symbol" },
      { "<leader>/",  "<leader>sg",                                         desc = "Find in Files (Grep)",   remap = true },
      { "<leader>:",  "<leader>sc",                                         desc = "Commands",               remap = true },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "~> ",
          selection_caret = " ",
          layout_strategy = "horizontal",
          layout_config = {
            prompt_position = "top",
          },
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          scroll_strategy = "cycle",
          color_devicons = true,
          -- sorting_strategy = 'ascending',
          mappings = {
            i = {
              ["<ESC>"] = actions.close,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
            n = {
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
            },
          },
        },
        pickers = {
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
            theme = "ivy",
            previewer = false,
          },
          git_files = {
            theme = "ivy",
          },
          find_files = {
            theme = "ivy",
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
          },
          live_grep = {
            theme = "ivy",
            -- @usage don't include the filename in the search results
            only_sort_text = true,
          },
        },
        extensions = {
          file_browser = {
            theme = "ivy",
            hijack_netrw = true,
            path = "%:p:h",
            cwd_to_path = true,
            path_display = { truncate = 3 },
          },
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      }
    end,
  },
}
