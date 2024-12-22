return {

  {
    'echasnovski/mini.icons',
    version = false,
    opts = {
      file = {
        ['.go-version'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['.eslintrc.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['.node-version'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['.prettierrc'] = { glyph = '', hl = 'MiniIconsPurple' },
        ['.yarnrc.yml'] = { glyph = '', hl = 'MiniIconsBlue' },
        ['eslint.config.js'] = { glyph = '󰱺', hl = 'MiniIconsYellow' },
        ['package.json'] = { glyph = '', hl = 'MiniIconsGreen' },
        ['tsconfig.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['tsconfig.build.json'] = { glyph = '', hl = 'MiniIconsAzure' },
        ['yarn.lock'] = { glyph = '', hl = 'MiniIconsBlue' },
      },
      filetype = {
        gotmpl = { glyph = '󰟓', hl = 'MiniIconsGrey' },
      },
    },
  },
  -- better text-objects
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }, {}),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }, {}),
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }, {}),
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
        },
      }
    end,
    config = function(_, opts)
      require('mini.ai').setup(opts)
    end,
  },

  -- buffer remove
  {
    'echasnovski/mini.bufremove',
    -- stylua: ignore
    keys = {
      { "<leader>bc", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bB", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
    },
  },
}
