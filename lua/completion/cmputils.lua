-- https://github.com/hrsh7th/nvim-cmp
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  print("This is not working again for cmp")
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

-- check autopairs for configuration
-- local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local lspkind = require("lspkind")

local source_mapping = {
  nvim_lsp = "[LSP]",
  nvim_lua = "[Lua]",
  cmp_tabnine = "[TN]",
  path = "[Path]",
  luasnip = "[Snp]",
  buffer = "[Buf]",
  emoji = "[Emj]",
}

local cmp_kinds = {
  Class = " ",
  Color = " ",
  Constant = "ﲀ ",
  Constructor = " ",
  Enum = "練",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = "",
  Folder = " ",
  Function = " ",
  Interface = "ﰮ ",
  Keyword = " ",
  Method = " ",
  Module = " ",
  Operator = "",
  Property = " ",
  Reference = " ",
  Snippet = " ",
  Struct = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = "塞",
  Value = " ",
  Variable = " ",
}

local check_backspace = function()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

-- require("luasnip/loaders/from_snipmate").lazy_load({ paths = "./snippets" })
luasnip.config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })

vim.api.nvim_command("hi LuasnipChoiceNodePassive cterm=italic")
vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  completion = {
    completeopt = "menu,menuone,noselect,noinsert",
  },
  formatting = {
    fields = { "abbr", "kind" },
    --fields = { "kind", "abbr", "menu" },
    format = lspkind.cmp_format({
      -- maxwidth = 50,
      preset = "default",
      before = function(entry, vim_item)
        vim_item.kind = (cmp_kinds[vim_item.kind] or "") .. vim_item.kind
        -- vim_item.kind = lspkind.presets.default[vim_item.kind]
        local menu = source_mapping[entry.source.name]
        if entry.source.name == "cmp_tabnine" then
          if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
            menu = entry.completion_item.data.detail .. " " .. menu
          end
          vim_item.kind = " "
        end
        vim_item.menu = menu
        return vim_item
      end,
    }),
  },
  mapping = {
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
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
  experimental = {
    ghost_text = true,
    native_menu = false,
  },
  view = {},
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  sources = {
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    -- { name = "cmp_tabnine" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "buffer",                 keyword_length = 5, max_item_count = 10 },
    { name = "path" },
    { name = "crates" },
    -- { name = "calc" },
  },
})

cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "buffer" },
  }),
})
