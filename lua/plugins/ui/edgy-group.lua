local function incline_safe_refresh()
  local ok, incline = pcall(require, 'incline')
  if ok then
    incline.refresh()
    vim.defer_fn(function()
      incline.refresh()
    end, 200)
    vim.defer_fn(function()
      incline.refresh()
    end, 400)
  end
end

return {
  {
    'lucobellic/edgy-group.nvim',
    dependencies = { 'folke/edgy.nvim' },
    keys = {
      {
        '<leader>;',
        function()
          require('edgy-group.stl').pick()
        end,
        desc = 'Edgy Group Pick',
        mode = { 'n', 'v' },
      },
      {
        '<c-;>',
        function()
          require('edgy-group.stl').pick()
        end,
        desc = 'Edgy Group Pick',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      groups = {
        left = {
          { icon = '', titles = { 'Neo-Tree', 'Neo-Tree Buffers' }, pick_key = 'e' },
          { icon = '', titles = { 'trouble-symbols' }, pick_key = 'o' },
          { icon = '', titles = { 'diffview-file-panel' }, pick_key = 'g' },
          {
            icon = '',
            titles = { 'dapui_scopes', 'dapui_watches' },
            pick_key = 'd',
          },
        },
        right = {
          { icon = '', titles = { 'codecompanion' }, pick_key = 'a' },
          {
            icon = '',
            titles = { 'avante', 'avante-files', 'avante-selected-files', 'avante-input' },
            pick_key = 'i',
          },
          { icon = '󰙨', titles = { 'neotest-summary' }, pick_key = 't' },
          {
            icon = '',
            titles = { 'dapui_stacks', 'dapui_breakpoints' },
            pick_key = 'd',
          },
        },
        bottom = {
          { icon = '', titles = { 'toggleterm', 'toggleterm-tasks', 'overseer' }, pick_key = 'p' },
          { icon = '', titles = { 'trouble-diagnostics', 'trouble-qflist' }, pick_key = 'x' },
          { icon = '', titles = { 'trouble-snacks', 'trouble-snacks-files' }, pick_key = 's' },
          { icon = '', titles = { 'trouble-lsp-references', 'trouble-lsp-definitions' }, pick_key = 'r' },
          { icon = '', titles = { 'noice' }, pick_key = 'n' },
          { icon = '󰙨', titles = { 'neotest-panel' }, pick_key = 't' },
          { icon = '', titles = { 'dap-repl', 'dapui_console' }, pick_key = 'd' },
        },
      },
      statusline = {
        clickable = true,
        colored = true,
        colors = {
          active = 'Identifier',
          inactive = 'Directory',
          pick_active = 'FlashLabel',
          pick_inactive = 'FlashLabel',
        },
        pick_key_pose = 'right_separator',
        pick_function = function(key)
          -- Use upper case to focus all element of the selected group while closing other (disable toggle)
          local toggle = not key:match('%u')
          local edgy_group = require('edgy-group')
          for _, group in ipairs(edgy_group.get_groups_by_key(key:lower())) do
            pcall(edgy_group.open_group_index, group.position, group.index, toggle)
          end
        end,
      },
    },
    config = function(_, opts)
      require('edgy-group').setup(opts)
      -- Add autocmd to refresh the statusline when the window is opened
      vim.api.nvim_create_autocmd({ 'WinResized' }, {
        pattern = { '*' },
        callback = function()
          incline_safe_refresh()
        end,
      })
    end,
  },
}
