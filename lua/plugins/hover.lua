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
    preview_opts = {
      border = 'rounded',
    },
    preview_window = false,
    title = true,
  },
  -- stylua: ignore
  keys = {
    { "K", function() require("hover").hover() end, desc = "Hover" },
    { "gk", function() require("hover").hover_select() end, desc = "Hover Select" },
  },
}
