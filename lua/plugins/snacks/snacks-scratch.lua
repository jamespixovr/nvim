return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    scratch = {
      enabled = true,
      name = 'SCRATCH',
      ft = function()
        if vim.bo.buftype == '' and vim.bo.filetype ~= '' then
          return vim.bo.filetype
        end
        return 'markdown'
      end,
      icon = nil,
      root = vim.fn.stdpath('data') .. '/scratch',
      autowrite = true,
      filekey = {
        cwd = true,
        branch = true,
        count = true,
      },
      win = {
        relative = 'editor',
        width = 0.8,
        height = 0.8,
        bo = { buftype = '', buflisted = false, bufhidden = 'hide', swapfile = false },
        minimal = false,
        noautocmd = false,
        zindex = 20,
        wo = { winhighlight = 'NormalFloat:Normal' },
        border = 'rounded',
        title_pos = 'center',
        footer_pos = 'center',

        keys = {
          -- ['execute'] = {
          --   '<cr>',
          --   function(_)
          --     vim.cmd('%SnipRun')
          --   end,
          --   desc = 'Execute buffer',
          --   mode = { 'n', 'x' },
          -- },
        },
      },
      win_by_ft = {
        lua = {
          -- keys = {
          --   ['source'] = {
          --     '<cr>',
          --     function(self)
          --       local name = 'scratch.' .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ':e')
          --       Snacks.debug.run({ buf = self.buf, name = name })
          --     end,
          --     desc = 'Source buffer',
          --     mode = { 'n', 'x' },
          --   },
          --   ['execute'] = {
          --     'e',
          --     function(_)
          --       vim.cmd('%SnipRun')
          --     end,
          --     desc = 'Execute buffer',
          --     mode = { 'n', 'x' },
          --   },
          -- },
        },
      },
    },
  },
}
