local tree_map = require("plugins.explorer.tree_mapping")
return {
  -- file explorer
  {
    "nvim-tree/nvim-tree.lua",
    -- event = "User DirOpened",
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Nvim Tree" },
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
      on_attach = tree_map.on_attach,
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
}
