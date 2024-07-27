local settings = require("settings")
local indent_exclude_fts = {
  "help",
  "alpha",
  "dashboard",
  "notify",
  "toggleterm",
  "lazyterm",
  "Trouble",
  "lazy",
  "mason",
  "NvimTree",
}

return {

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
    keys = {
      { "<Tab>", "j", ft = "DressingSelect" },
      { "<S-Tab>", "k", ft = "DressingSelect" },
    },
    --[[
    opts = {                 -- adapted from https://github.com/chrisgrieser/.config/blob/main/nvim/lua/plugins/appearance.lua
      input = {
        insert_only = false, -- = enable normal mode
        trim_prompt = true,
        border = vim.g.borderStyle,
        relative = "editor",
        title_pos = "left",
        prefer_width = 73, -- commit width + 1 for padding
        min_width = 0.4,
        max_width = 0.9,
        mappings = { n = { ["q"] = "Close" } },
      },
      select = {
        backend = { "telescope", "builtin" },
        trim_prompt = true,
        builtin = {
          mappings = { ["q"] = "Close" },
          show_numbers = false,
          border = vim.g.borderStyle,
          relative = "editor",
          max_width = 80,
          min_width = 20,
          max_height = 12,
          min_height = 3,
        },
        telescope = {
          layout_config = {
            horizontal = { width = { 0.7, max = 75 }, height = 0.6 },
          },
        },
        get_config = function(opts)
          local useBuiltin = { "just-recipes", "codeaction", "rule_selection" }
          if vim.tbl_contains(useBuiltin, opts.kind) then
            return { backend = { "builtin" }, builtin = { relative = "cursor" } }
          end
        end,
      },
    },
    --]]
  },
  --------------------------------------------------------------------------
  -- Tabs
  {
    "akinsho/nvim-bufferline.lua",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "[b",         "<cmd>BufferLineCyclePrev<cr>",                              desc = "Previous" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",                              desc = "Next" },
      { "<leader>bq", "<cmd>BufferLineCloseLeft<cr><cmd>BufferLineCloseRight<cr>", desc = "Close All Tabs" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",                              desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>",                   desc = "Delete non-pinned buffers" },
      { "<leader>bt", "<cmd>BufferLinePick<cr>",                                   desc = "Pick Tab" },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>',                              desc = 'Close buffers to the left' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>',                             desc = 'Close buffers to the right' },
      { '<leader>bc', '<cmd>BufferLinePickClose<cr>',                              desc = 'Select a buffer to close' },
    },
    opts = {
      options = {
        -- stylua: ignore
        close_command = function(n) require("mini.bufremove").delete(n, false) end,
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
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
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

  --------------------------------------------------------------------------
  --------------------------------------------------------------------------
  -- folding fold area
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
		-- stylua: ignore start
    keys = {
      { "zR", function() require("ufo").openFoldsExceptKinds {} end, desc = "󱃄 Open All Folds" },
      { "zM", function() require("ufo").closeAllFolds() end, },
      { "zr", function(...) require("ufo").openFoldsExceptKinds(...) end, },
      { "zm", function() require("ufo").closeAllFolds() end, desc = "󱃄 Close All Folds" },
      {
        'zk',
        function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Preview fold or hover"
      },
      { "z1", function() require("ufo").closeFoldsWith(1) end, desc = "󱃄 Close L1 Folds" },
			{ "z2", function() require("ufo").closeFoldsWith(2) end, desc = "󱃄 Close L2 Folds" },
			{ "z3", function() require("ufo").closeFoldsWith(3) end, desc = "󱃄 Close L3 Folds" },
			{ "z4", function() require("ufo").closeFoldsWith(4) end, desc = "󱃄 Close L4 Folds" },
    },
    -- stylua: ignore end
    init = function()
      -- INFO fold commands usually change the foldlevel, which fixes folds, e.g.
      -- auto-closing them after leaving insert mode, however ufo does not seem to
      -- have equivalents for zr and zm because there is no saved fold level.
      -- Consequently, the vim-internal fold levels need to be disabled by setting
      -- them to 99.
      vim.opt.foldlevel = 99
      vim.opt.foldlevelstart = 99
    end,
    opts = function()
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
        open_fold_hl_timeout = 800,
        -- when opening the buffer, close these fold kinds
        -- use `:UfoInspect` to get available fold kinds from the LSP
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
          json = { "array" },
          c = { "comment", "region" },
        },
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
        provider_selector = function(_, ft, _)
          -- INFO some filetypes only allow indent, some only LSP, some only
          -- treesitter. However, ufo only accepts two kinds as priority,
          -- therefore making this function necessary :/
          local lspWithOutFolding = { "markdown", "sh", "css", "html", "python", "json" }
          if vim.tbl_contains(lspWithOutFolding, ft) then
            return { "treesitter", "indent" }
          end
          return { "lsp", "indent" }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
  --------------------------------------------------------------------------

  -- ui components
}
