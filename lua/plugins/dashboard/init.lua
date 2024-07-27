-- local helper = require("helper")
local settings = require("settings")

return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    init = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
        "echasnovski/mini.indentscope",
        opts = function()
          -- disable indentation scope for the current ("alpha" filetype) buffer
          vim.cmd([[
        autocmd Filetype alpha lua vim.b.miniindentscope_disable = true
      ]])
        end,
      },
    },

    config = function()
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
        header_logo[i] = {
          type = "text",
          val = line,
          opts = { hl = "StartLogo" .. i, position = "center" },
        }
      end

      dashboard.section.header.type = "group"
      dashboard.section.header.val = header_logo
      -- dashboard.section.header.val = require("util.logo")["random"]
      dashboard.section.buttons.val = {
        dashboard.button("f", settings.icons.ui.Search2 .. " Find file", "<cmd>Telescope find_files<cr>"),
        dashboard.button("n", " " .. " New file", "<cmd>ene <bar> startinsert <cr>"),
        dashboard.button("r", " " .. " Recent files", "<cmd>Telescope frecency workspace=CWD <cr>"),
        dashboard.button("/", " " .. " Find text", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("p", " " .. " Open project", "<cmd>Telescope project display_type=full<cr>"),
        -- dashboard.button("c", " " .. " Config", "<cmd>e $MYVIMRC<cr>"),
        dashboard.button("s", "勒" .. " Restore Session", ":lua require('persistence').load()<cr>"),
        dashboard.button("l", "鈴" .. " Lazy", "<cmd>Lazy<cr>"),
        -- dashboard.button("u", " " .. " Update plugins", ":Lazy sync<CR>"),
        dashboard.button("q", " " .. " Quit", "<cmd>qa<cr>"),
      }
      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.footer.opts.hl = "AlphaFooter"
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.config.layout[1].val = 5

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

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          local date = os.date("%d-%m-%Y")
          local time = os.date("%H:%M:%S")
          dashboard.section.footer.val = "[  Loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms] [ "
            .. date
            .. "] [ "
            .. time
            .. "]"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
