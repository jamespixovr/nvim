return {
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = function()
      local status = require("plugins.lualine.status")
      return {
        options = {
          theme = "catppuccin",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "lazy", "alpha" },
            winbar = { "lazy", "alpha", "toggleterm", "NvimTree", "Trouble", "neo-tree" },
          },
          globalstatus = true,
          always_divide_middle = true,
          refresh = {
            statusline = 200,
            tabline = 1000,
            winbar = 1000,
          },
        },
        tabline = {},
        sections = {
          lualine_a = {
            status.mode(),
          },
          lualine_b = {
            status.branch(),
            status.git_diff(),
            status.diagnostics(),
          },
          lualine_c = {
            '%=',
            status.filename(),
          },
          lualine_x = {
            status.LazyUpdates(),
            status.Overseer(),
            status.showMacroRecording(),
            status.filetype(),
            status.treesitter(),
          },
          lualine_y = {
            status.lsp(),
          },
          lualine_z = {
            status.progress(),
            status.scrollbar(),
          },
        },
        extensions = { "nvim-tree", "trouble", "quickfix", "man", "toggleterm" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  }
}
