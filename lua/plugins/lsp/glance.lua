---@diagnostic disable: missing-fields
return {
  {
    'dnlhc/glance.nvim',
    event = 'LspAttach',
    cmd = { 'Glance' },
    keys = {
      { 'gt', '<CMD>Glance resume<CR>', desc = 'Glance Resume' },
    },
    opts = {
      use_trouble_qf = true,
      height = 20,
      zindex = 45,
      detached = function(win)
        return vim.api.nvim_win_get_width(win) < 80
      end,
      border = {
        enable = true,
      },
      hooks = {
        before_open = function(results, open, jump, method)
          if #results == 1 then
            jump(results[1])
          else
            open(results)
          end
        end,
      },
      folds = {
        fold_closed = '',
        fold_open = '',
        folded = true,
      },
      indent_lines = {
        enable = true,
        icon = '│',
      },
      theme = {
        enable = true,
      },
      winbar = {
        enable = true,
      },
    },
  },
}
