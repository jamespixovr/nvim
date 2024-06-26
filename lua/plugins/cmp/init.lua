local settings = require("settings")

return {
  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      {
        "rafamadriz/friendly-snippets",
        config = function()
          local luasnip = require("luasnip")
          luasnip.filetype_extend("javascriptreact", { "html" })
          luasnip.filetype_extend("typescriptreact", { "html" })
          luasnip.filetype_extend("svelte", { "html" })
          luasnip.filetype_extend("vue", { "html" })

          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
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
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = false, -- last release is way too old
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")
      local compare = require("cmp.config.compare")

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
          { name = "nvim_lsp", group_index = 1 },
          { name = "nvim_lua", group_index = 1 },
          { name = "codeium" },
          { name = "luasnip", group_index = 1 },
          { name = "path", group_index = 1 },
          { name = "buffer", group_index = 2, keyword_length = 5 },
        },
        window = {
          completion = { border = vim.g.borderStyle, scrolloff = 2 },
          documentation = { border = vim.g.borderStyle, scrolloff = 2 },
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            maxwidth = 60,
            preset = "default",
            before = function(entry, item)
              local kind = item.kind --> Class, Method, Variables...
              local icons = settings.icons.kinds[kind]
              item.kind = (icons or "?")
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
          }),
        },
        experimental = {
          -- ghost_text = false,
          ghost_text = {
            hl_group = "LspCodeLens",
          },
        },
        enabled = function()
          -- disable completion in comments
          local context = require("cmp.config.context")
          -- keep command mode completion enabled when cursor is in a comment
          if vim.api.nvim_get_mode().mode == "c" then
            return true
          else
            local buftype = vim.api.nvim_buf_get_option(0, "buftype")
            if buftype == "prompt" then
              return false
            end
            return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          end
        end,
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "path", group_index = 1 },
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
}
