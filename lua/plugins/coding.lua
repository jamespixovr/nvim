return {
  -- Generate Docs
  {
    'danymat/neogen',
    lazy = true,
    dependencies = 'nvim-treesitter/nvim-treesitter',
    keys = {
      { '<leader>cn', ':Neogen<cr>', desc = 'Generate Annotation' },
    },
  },

  -- rename
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },
}
