-- noicer lua
return {
  "folke/noice.nvim",
  lazy = false,
  enabled = true,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    views = {
      cmdline_popup = {
        position = {
          row = 15,
          col = "50%",
        },
        size = {
          width = 75,
          height = "auto",
        },
      },
      popupmenu = {
        relative = "editor",
        position = {
          row = 8,
          col = "50%",
        },
        size = {
          width = 60,
          height = 10,
        },
        border = {
          style = "rounded",
          padding = { 0, 1 },
        },
        -- win_options = {
        --   winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
        -- },
      },
    },
    lsp = {
      progress = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      hover = {
        enabled = false,
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      -- long_message_to_split = false,
      inc_rename = true,
      cmdline_output_to_split = false,
      lsp_doc_border = true,
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
      {
        filter = { event = "msg_show", find = "^%d+ lines yanked$" },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "vim.lsp.get_active_clients()",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          find = "sign-define or sign_define()",
        },
        opts = { skip = true },
      },
    },
  },
  keys = {
    {
      "<S-Enter>",
      function()
        require("noice").redirect(vim.fn.getcmdline())
      end,
      mode = "c",
      desc = "Redirect Cmdline",
    },
    {
      "<leader>nl",
      function()
        require("noice").cmd("last")
      end,
      desc = "Noice Last Message",
    },
    {
      "<leader>nh",
      function()
        require("noice").cmd("history")
      end,
      desc = "Noice History",
    },
    {
      "<leader>na",
      function()
        require("noice").cmd("all")
      end,
      desc = "Noice All",
    },
    {
      "<leader>nd",
      function()
        require("noice").cmd("dismiss")
      end,
      desc = "Dismiss All",
    },
    {
      "<c-f>",
      function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll forward",
      mode = { "i", "n", "s" },
    },
    {
      "<c-b>",
      function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end,
      silent = true,
      expr = true,
      desc = "Scroll backward",
      mode = { "i", "n", "s" },
    },
  },
}
