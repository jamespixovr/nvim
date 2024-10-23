---@diagnostic disable: missing-fields
return {
  {
    'dnlhc/glance.nvim',
    enabled = false,
    event = 'VeryLazy',
    cmd = { 'Glance' },
    opts = {
      use_trouble_qf = true,
      height = 20,
      zindex = 45,
      border = {
        enable = true,
      },
      hooks = {
        before_open = function(results, open, jump, method)
          local uri = vim.uri_from_bufnr(0)
          if #results == 1 then
            local target_uri = results[1].uri or results[1].targetUri

            if target_uri == uri then
              jump(results[1])
            else
              open(results)
            end
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
      winbar = {
        enable = true,
      },
    },
  },
}
