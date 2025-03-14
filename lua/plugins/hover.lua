return {
  'lewis6991/hover.nvim',
  enabled = false,
  init = function()
    require('hover.providers.lsp')
    -- require('hover.providers.gh')
    -- require('hover.providers.gh_user')
    -- require('hover.providers.jira')
    require('hover.providers.dap')
    require('hover.providers.man')
    require('hover.providers.fold_preview')
    -- require('hover.providers.dictionary')
    require('hover.providers.diagnostic')
  end,
  opts = {
    preview_opts = { border = 'rounded' },
    preview_window = false,
    title = true,
    mouse_providers = { 'LSP' },
    mouse_delay = 1000,
  },
  keys = {
    {
      'K',
      function()
        require('hover').hover()
      end,
      desc = 'Hover',
    },
    {
      'gk',
      function()
        require('hover').hover_select()
      end,
      desc = 'Hover Select',
    },
    {
      '[h',
      function()
        require('hover').hover_switch('previous')
      end,
      desc = 'Previous hover provider.',
      mode = 'n',
      noremap = true,
    },
    {
      ']h',
      function()
        require('hover').hover_switch('next')
      end,
      desc = 'Next hover provider.',
      mode = 'n',
      noremap = true,
    },
  },
}
