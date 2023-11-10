local settings = require("settings")
local indent_exclude_fts = {
  "help", "alpha", "dashboard",
  "notify", "toggleterm", "lazyterm", "Trouble", "lazy",
  "mason", "NvimTree"
}
-- local highlight = {
--   "CursorColumn",
--   "Whitespace",
-- }

return {
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      background_colour = "#000000",
      -- stages = "slide",
      -- level = 0,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      -- Icons for the different levels
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },

    },
  },
  --------------------------------------------------------------------------

  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        insert_only = true,
        win_options = {
          winblend = 0,
        },
      },
      select = {
        telescope = require('telescope.themes').get_cursor({
          layout_config = {
            width = function(_, max_columns, _)
              return math.min(max_columns, 80)
            end,
            height = function(_, _, max_lines)
              return math.min(max_lines, 15)
            end,
          },
        }),
      },
    },
    config = function(_, opts)
      require("dressing").setup(opts)
    end,
  },
  --------------------------------------------------------------------------
  -- Tabs
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next" },
      {
        "<c-,>",
        "<esc><cmd>BufferLineCyclePrev<cr>",
        desc = "Previous Buffer",
        mode = { "n", "i" }
      },
      {
        "<c-.>",
        "<esc><cmd>BufferLineCycleNext<cr>",
        desc = "Next Buffer",
        mode = { "n", "i" }
      },
      { "<leader>bt", "<cmd>BufferLinePick<cr>",                                   desc = "Pick Tab" },
      { "<leader>bq", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Close All Tabs" },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>',                              desc = 'Close buffers to the left' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>',                             desc = 'Close buffers to the right' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>',                              desc = 'Select a buffer to close' },


    },
    opts = {
      options = {
        numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        show_close_icon = false,
        show_buffer_close_icons = false,
        show_buffer_icons = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        separator_style = "thin",
        diagnostics_indicator = function(_, _, diag)
          local icons = settings.icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
              .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
            padding = 1,
          },
        },
      },
    },
  },
  --------------------------------------------------------------------------

  --------------------------------------------------------------------------
  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      -- indent = { highlight = highlight, char = "" },
      -- whitespace = {
      --   highlight = highlight,
      --   remove_blankline_trail = false,
      -- },
      scope = { enabled = false },
      exclude = {
        filetypes = indent_exclude_fts,
      },
    },
    main = "ibl",
  },

  -- Active indent guide and indent text objects. When you're browsing
  -- code, this highlights the current level of indentation, and animates
  -- the highlighting.
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  --------------------------------------------------------------------------
  -- noicer lua
  {
    "folke/noice.nvim",
    cond = true,
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      views = {
        cmdline_popup = {
          position = {
            row = 10,
            col = "50%",
          },
          size = {
            width = 70,
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
        }
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
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
          filter = { event = 'msg_show', find = '^%d+ lines yanked$' },
          opts = { skip = true },
        },
      },
    },
    -- stylua: ignore
    keys = {
      {
        "<S-Enter>",
        function() require("noice").redirect(vim.fn.getcmdline()) end,
        mode = "c",
        desc =
        "Redirect Cmdline"
      },
      { "<leader>nl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
      { "<leader>nh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>na", function() require("noice").cmd("all") end,     desc = "Noice All" },
      { "<leader>nd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      {
        "<c-f>",
        function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" }
      },
      {
        "<c-b>",
        function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" }
      },

    },
  },
  --------------------------------------------------------------------------
  -- folding fold area
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    --stylua: ignore
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, },
      { "zM", function() require("ufo").closeAllFolds() end, },
      { "zr", function(...) require("ufo").openFoldsExceptKinds(...) end, },
      { "zm", function(...) require("ufo").closeFoldsWith(...) end, },
      {
        'zK',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Preview fold or hover"
      }
    },
    opts = function()
      local ts_indent = { "treesitter", "indent" }
      local ft_map = {
        vim = "indent",
        python = "indent",
        git = "",
        markdown = ts_indent,
      }
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = ("  %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end
      return {
        open_fold_hl_timeout = 0,
        close_fold_kinds = { "imports", "comment" },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
          },
        },
        provider_selector = function(_, filetype, _)
          return ft_map[filetype] or { "lsp", "indent" }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
  --------------------------------------------------------------------------

  -- icons
  { "nvim-tree/nvim-web-devicons" },
  -- ui components
  { "MunifTanjim/nui.nvim" },
}
