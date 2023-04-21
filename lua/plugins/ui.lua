local settings = require("settings")
local helper = require("helper")
local indent_exclude_fts = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason", "NvimTree" }

return {
  -- add folding range to capabilities
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>snd",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Delete all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      background_color = "#000000",
      stages = "static",
      level = 0,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },

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
  -- Tabs
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    keys = {
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",                              desc = "Previous" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",                              desc = "Next" },
      { "[B",         "<cmd>BufferLineMovePrev<cr>",                               desc = "Previous" },
      { "]B",         "<cmd>BufferLineMoveNext<cr>",                               desc = "Next" },
      { "<leader>tp", "<cmd>BufferLinePick<cr>",                                   desc = "Pick" },
      { "<leader>ta", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Only" },
      -- { "<s-h>",      "[b",                                                        desc = "Prev Buffer", remap = true },
      -- { "<s-l>",      "]b",                                                        desc = "Next Buffer", remap = true },
    },
    opts = {
      options = {
        numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        show_close_icon = false,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        separator_style = "thin",
        diagnostics_indicator = function(_, _, diagnostics_dict)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and " " or (e == "warning" and " " or "")
            s = s .. sym .. n
          end
          return s
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

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      local symbols = settings.icons
      return {
        options = {
          theme = "auto",
          icons_enabled = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = { "lazy", "alpha" },
            winbar = { "lazy", "alpha", "toggleterm", "NvimTree", "Trouble", "neo-tree" },
          },
          globalstatus = true,
          refresh = {
            statusline = 100,
          },
        },
        ---@diagnostic disable: unused-local
        sections = {
          lualine_a = {
            {
              "headers",
              fmt = function(content, context)
                return "  "
              end,
            },
          },
          lualine_b = {
            { "branch", icon = "" },
            {
              "mode",
              fmt = function(content, context)
                return ("-- %s --"):format(content)
              end,
            },
          },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = symbols.diagnostics.Error,
                warn = symbols.diagnostics.Warn,
                info = symbols.diagnostics.Info,
                hint = symbols.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = {
                left = 1, right = 0 }
            },
            { "filename", path = 1, symbols = { modified = " ", readonly = " ", unnamed = " " } },
          },
          lualine_x = {
            {
              "space_style",
              fmt = function(content, context)
                local expand = vim.opt_local.expandtab:get()
                local widht = vim.opt_local.shiftwidth:get()
                local style = expand and "Spaces" or "Tab Size"
                return ("%s: %s"):format(style, widht)
              end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = helper.get_fg("Statement"),
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = helper.get_fg("Constant"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = helper.get_fg("Special"),
            },
            {
              "diff",
              source = function()
                ---@diagnostic disable-next-line: undefined-field
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              symbols = {
                added = symbols.git.added,
                modified = symbols.git.modified,
                removed = symbols.git.removed,
              }, -- changes diff symbols
            },
          },
          lualine_y = {
            { "location", padding = { left = 0, right = 1 } },
            { "progress" },
          },
          lualine_z = {
            {
              "filetype",
              icons_enabled = false,
            },
            {
              "decorate",
              fmt = function(content, context)
                return "   "
              end,
            },
          },
        },
        extensions = { "nvim-tree" },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      use_treesitter = true,
      filetype_exclude = indent_exclude_fts,
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },
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
      lsp = {
        progress = {
          enabled = false,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
          ["vim.lsp.util.stylize_markdown"] = false,
          ["cmp.entry.get_documentation"] = false,
        },
        signature = {
          enabled = false,
        },
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
          view = "notify",
          filter = { find = "overly long" },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
          view = "mini",
        },
        {
          filter = {
            event = "msg_show",
            kind = "",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            find = "search hit",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "msg_show",
            kind = "search_count",
          },
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
      { "<leader>snl", function() require("noice").cmd("last") end,    desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end,     desc = "Noice All" },
    },
  },
  -- folding
  -- fold area
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
        'K',
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
  -- icons
  { "nvim-tree/nvim-web-devicons" },
  -- ui components
  "MunifTanjim/nui.nvim",
  -- figet
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup({})
    end,
  },

  {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VimEnter",
    cond = helper.is_directory_or_nil,
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = {
        "                                                                   ",
        "      ████ ██████           █████      ██                    ",
        "     ███████████             █████                            ",
        "     █████████ ███████████████████ ███   ███████████  ",
        "    █████████  ███    █████████████ █████ ██████████████  ",
        "   █████████ ██████████ █████████ █████ █████ ████ █████  ",
        " ███████████ ███    ███ █████████ █████ █████ ████ █████ ",
        "██████  █████████████████████ ████ █████ █████ ████ ██████",
      }

      local header_logo = {}
      for i, line in ipairs(logo) do
        header_logo[i] = { type = "text", val = line, opts = { hl = "StartLogo" .. i, position = "center" } }
      end

      dashboard.section.header.type = "group"
      dashboard.section.header.val = header_logo
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", " " .. " New file", "<cmd>ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files", "<cmd>Telescope frecency workspace=CWD <cr>"),
        dashboard.button("g", " " .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("p", " " .. " Open project", "<cmd>Telescope project display_type=full<cr>"),
        dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("s", "勒" .. " Restore Session", ":lua require('persistence').load()<cr>"),
        dashboard.button("l", "鈴" .. " Lazy", "<cmd>Lazy<cr>"),
        dashboard.button("u", " " .. " Update plugins", ":Lazy sync<CR>"),
        dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "Type"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.config.layout[1].val = 8

      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      dashboard.config.opts.autostart = false

      return dashboard.config
    end,
    config = function(_, opts)
      require("alpha").setup(opts)

      local function run_alpha()
        local buf = vim.api.nvim_get_current_buf()
        if helper.is_directory() then
          vim.api.nvim_set_current_dir(vim.api.nvim_buf_get_name(buf))
        end
        require("alpha").start(false, opts)
        vim.api.nvim_buf_delete(buf, {})
      end

      run_alpha()
    end,
  },
  {
    -- rainbow brackets
    "HiPhish/nvim-ts-rainbow2",
    event = "BufEnter",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
}
