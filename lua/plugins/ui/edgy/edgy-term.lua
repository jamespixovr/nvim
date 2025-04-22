return {
  'folke/edgy.nvim',
  opts = {
    bottom = {
      { ft = 'qf', title = 'QuickFix' },
      {
        ft = 'snacks_terminal',
        size = { height = 0.4 },
        title = '%{b:snacks_terminal.id}: %{b:term_title}',
        filter = function(_buf, win)
          return vim.w[win].snacks_win
            and vim.w[win].snacks_win.position == 'bottom'
            and vim.w[win].snacks_win.relative == 'editor'
            and not vim.w[win].trouble_preview
        end,
      },
      {
        title = 'toggleterm',
        ft = 'toggleterm',
        open = function()
          local buffers = vim.tbl_filter(function(buf)
            local bufname = vim.fn.bufname(buf.bufnr)
            return bufname:find('toggleterm') ~= nil and bufname:find('toggleterm.lua') == nil
          end, vim.fn.getbufinfo({ buflisted = 0, buftype = 'terminal' }))

          local toggleterm_open = #require('toggleterm.terminal').get_all(true) > 1
          local terminal_open = toggleterm_open or #buffers > 0

          -- Create a terminal if none exist, otherwise toggle all terminals
          if terminal_open then
            -- Toggle all terminal buffers with name containing 'toggleterm'
            vim.tbl_map(function(buf)
              vim.cmd('sbuffer ' .. buf.bufnr)
            end, buffers)
            if toggleterm_open then
              require('toggleterm').toggle_all()
            end
          else
            require('toggleterm').toggle()
          end
        end,
      },
      {
        title = 'toggleterm-tasks',
        ft = '',
        filter = function(buf)
          local is_term = vim.bo[buf].buftype == 'terminal'
          local is_toggleterm = vim.fn.bufname(buf):find('toggleterm')
          return is_term and is_toggleterm
        end,
        open = '',
      },
      {
        title = 'overseer',
        ft = 'OverseerList',
        open = 'OverseerToggle!',
        size = { width = 0.15 },
      },
      {
        ft = 'help',
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == 'help'
        end,
      },
    },
  },
}
