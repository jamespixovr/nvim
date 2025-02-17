return {
  -- Generate Docs
  {
    'danymat/neogen',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    keys = {
      { '<leader>cn', ':Neogen<cr>', desc = 'Generate Annotation' },
    },
    opts = function(_, opts)
      if opts.snippet_engine ~= nil then
        return
      end

      opts.snippet_engine = 'luasnip'

      -- if vim.snippet then
      --   opts.snippet_engine = 'nvim'
      -- end
    end,
  },

  -- rename
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
}
