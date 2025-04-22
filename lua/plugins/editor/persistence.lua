return {
  'folke/persistence.nvim',
  event = 'VimEnter',
  lazy = false,
  init = function()
    -- https://neovim.io/doc/user/options.html#'sessionoptions'
    vim.opt.sessionoptions = 'curdir,folds,help,winsize,winpos,localoptions'
  end,
  opts = { options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help' } },
  config = function(_, opts)
    require('persistence').setup(opts)
  end,
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end,                desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end,                desc = "Don't Save Current Session" }
    }
,
}
