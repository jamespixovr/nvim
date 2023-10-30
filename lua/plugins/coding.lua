local settings = require("settings")

return {
  {
    "L3MON4D3/LuaSnip",
    event = 'InsertEnter',
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = false,
      -- delete_check_events = "TextChanged",
      updateevents = "TextChanged,TextChangedI",
      -- Event on which to check for exiting a snippet's region
      region_check_events = 'InsertEnter',
      delete_check_events = 'InsertLeave',
      ft_func = function()
        return vim.split(vim.bo.filetype, '.', { plain = true })
      end,
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s", },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" }, },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local compare = require "cmp.config.compare"
      --[[ local maxline = 50
      local ellipsis = "..."
      local menu = {
        luasnip = "[Snip]",
        nvim_lsp = "[Lsp]",
        buffer = "[Buf]",
        path = "[Path]",
        cmdline = "[Cmd]",
      } ]]
      local check_backspace = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
      end
      local function toggle_cmp()
        if cmp.visible() then
          cmp.close()
        else
          cmp.complete()
        end
      end
      return {
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect,noinsert",
          -- completeopt = "menu,menuone,noinsert",
        },
        sorting = {
          priority_weight = 2,
          comparators = {
            compare.score,
            compare.recently_used,
            compare.offset,
            compare.exact,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = { i = toggle_cmp, c = toggle_cmp },
          ["<C-e>"] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          }),
          --['<ESC>'] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expandable() then
              luasnip.expand()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif check_backspace() then
              fallback()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp",                group_index = 1 },
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "nvim_lua",                group_index = 1 },
          { name = "luasnip",                 group_index = 1 },
          { name = "path",                    group_index = 1 },
          { name = "buffer",                  group_index = 2, keyword_length = 5 },
          -- { name = "cmp_tabnine",             group_index = 2 }
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            maxwidth = 60,
            preset = "default",
            before = function(entry, item)
              local kind = item.kind --> Class, Method, Variables...
              local icons = settings.icons.kinds[kind]
              item.kind = (icons or '?')
              if entry.source.name == "cmp_tabnine" then
                if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                  -- kind = entry.completion_item.data.detail .. " " .. menu
                  kind = "Tabnine"
                end
                item.kind = " "
              end

              item.menu = " (" .. kind .. ") "
              return item
            end,
          })
        },
        experimental = {
          -- ghost_text = false,
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
        enabled = function()
          -- disable completion in comments
          local context = require 'cmp.config.context'
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == 'c' then
            return true
          else
            local buftype = vim.api.nvim_buf_get_option(0, "buftype")
            if buftype == "prompt" then return false end
            return not context.in_treesitter_capture("comment")
                and not context.in_syntax_group("Comment")
          end
        end
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path",    group_index = 1 },
          { name = "cmdline", group_index = 2 },
        },
      })
      for _, cmd_type in ipairs({ "/", "?" }) do
        cmp.setup.cmdline(cmd_type, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = "buffer", group_index = 1 },
          },
        })
      end
      local autopair_ok, cmp_autopairs = pcall(require, "nvim-autopairs.completion.cmp")
      if autopair_ok then
        -- https://github.com/windwp/nvim-autopairs
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", italic = true })
    end,
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      enable_check_bracket_line = false,
      fast_wrap = {
        map = "<C-h>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "Search",
        highlight_grey = "Comment",
      },
    },
    config = function(_, plugin_opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(plugin_opts)

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
      npairs.add_rules({
        Rule(" ", " ")
            :with_pair(function(opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opts)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opts.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end),
      })
      for _, bracket in pairs(brackets) do
        Rule("", " " .. bracket[2])
            :with_pair(cond.none())
            :with_move(function(opts)
              return opts.char == bracket[2]
            end)
            :with_cr(cond.none())
            :with_del(cond.none())
            :use_key(bracket[2])
      end
    end,
  },

  -- surround
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function(_, opts)
      require("nvim-surround").setup(opts)
    end,
  },
  -- comments
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", desc = "+comment line",  mode = { "n", "x" } },
      { "gb", desc = "+comment block", mode = { "n", "x" } },
    },
    opts = function()
      return {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
    config = function(_, opts)
      require("Comment").setup(opts)
    end,
  },
  -- better text-objects
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
        end,
      },
    },
    opts = function()
      local ai = require("mini.ai")
      ---@param func function
      local function wrap_mark(func)
        return function(...)
          vim.cmd("normal! m'")
          return func(...)
        end
      end
      return {
        n_lines = 500,
        custom_textobjects = {
          o = wrap_mark(ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {})),
          f = wrap_mark(ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {})),
          c = wrap_mark(ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {})),
          -- Whole buffer
          e = wrap_mark(function()
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              ---@diagnostic disable-next-line: param-type-mismatch, undefined-field
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  -- Generate Docs
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  {
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension "refactoring"
    end,
    -- stylua: ignore
    keys = {
      {
        "<leader>rs",
        function() require("telescope").extensions.refactoring.refactors() end,
        mode = { "v" },
        desc =
        "Refactor",
      },
      {
        "<leader>ri",
        function() require("refactoring").refactor("Inline Variable") end,
        mode = { "n", "v" },
        desc =
        "Inline Variable"
      },
      {
        "<leader>rb",
        function() require('refactoring').refactor('Exract Block') end,
        mode = { "n" },
        desc =
        "Extract Block"
      },
      {
        "<leader>rf",
        function() require('refactoring').refactor('Exract Block To File') end,
        mode = { "n" },
        desc =
        "Extract Block to File"
      },
      {
        "<leader>rP",
        function() require('refactoring').debug.printf({ below = false }) end,
        mode = { "n" },
        desc =
        "Debug Print"
      },
      {
        "<leader>rp",
        function() require('refactoring').debug.print_var({ normal = true }) end,
        mode = { "n" },
        desc =
        "Debug Print Variable"
      },
      {
        "<leader>rc",
        function() require('refactoring').debug.cleanup({}) end,
        mode = { "n" },
        desc =
        "Debug Cleanup"
      },
      {
        "<leader>rf",
        function() require('refactoring').refactor('Extract Function') end,
        mode = { "v" },
        desc =
        "Extract Function"
      },
      {
        "<leader>rF",
        function() require('refactoring').refactor('Extract Function to File') end,
        mode = { "v" },
        desc =
        "Extract Function to File"
      },
      {
        "<leader>rx",
        function() require('refactoring').refactor('Extract Variable') end,
        mode = { "v" },
        desc =
        "Extract Variable"
      },
      {
        "<leader>rp",
        function() require('refactoring').debug.print_var({}) end,
        mode = { "v" },
        desc =
        "Debug Print Variable"
      },
    },
  },
  {
    "ray-x/lsp_signature.nvim",
    keys = {
      {
        "<leader>ls",
        function()
          require('lsp_signature').toggle_float_win()
        end,
        silent = true,
        noremap = true,
        desc = "Toggle Signature"
      },
      {
        "<leader>k",
        function()
          vim.lsp.buf.signature_help()
        end,
        silent = true,
        noremap = true,
        desc = "Toggle Signature"
      }
    },
    opts = {
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      handler_opts = {
        border = "rounded"
      }
    }
  }
}
