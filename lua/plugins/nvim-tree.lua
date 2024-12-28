local icons = require('lib.icons')

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return {
      desc = 'nvim-tree: ' .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.set('n', 'Y', api.fs.copy.filename, opts('Copy Name'))
  vim.keymap.set('n', 'y', api.fs.copy.relative_path, opts('Copy Relative Path'))
  vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
  vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
  vim.keymap.set('n', 'o', api.node.open.horizontal, opts('Open: Horizontal Split'))
  vim.keymap.set('n', 'd', api.fs.trash, opts('Trash'))
end

return {
  -- file explorer
  {
    'nvim-tree/nvim-tree.lua',
    -- event = "User DirOpened",
    lazy = false,
    keys = {
      { '<leader>e', '<cmd>NvimTreeToggle<cr>', desc = 'Nvim Tree' },
    },
    config = function()
      local nvim_tree = require('nvim-tree')
      local Snacks = require('snacks')

      local prev = { new_name = '', old_name = '' } -- Prevents duplicate events
      vim.api.nvim_create_autocmd('User', {
        pattern = 'NvimTreeSetup',
        callback = function()
          local events = require('nvim-tree.api').events
          events.subscribe(events.Event.NodeRenamed, function(data)
            if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
              data = data
              Snacks.rename.on_rename_file(data.old_name, data.new_name)
            end
          end)
        end,
      })

      nvim_tree.setup({
        on_attach = on_attach,
        disable_netrw = true,
        hijack_cursor = true,
        filters = { dotfiles = true },

        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = { 'fzf', 'help', 'git' },
        },
        diagnostics = {
          enable = true,
          icons = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Information,
            warning = icons.diagnostics.Warning,
            error = icons.diagnostics.Error,
          },
          show_on_dirs = true,
        },
        actions = { open_file = { quit_on_open = true } },
        view = {
          adaptive_size = true,
          width = 40,
          signcolumn = 'no',
        },
        renderer = {
          add_trailing = false,
          group_empty = true,
          highlight_git = true,
          highlight_opened_files = 'none',
          root_folder_modifier = ':~',
          indent_markers = {
            enable = false,
            icons = { corner = icons.ui.Corner, edge = icons.ui.Edge, none = icons.ui.Edge },
          },
          icons = {
            webdev_colors = true,
            git_placement = 'before',
            padding = ' ',
            symlink_arrow = icons.ui.Arrow,
            show = { file = true, folder = true, folder_arrow = true, git = true },
            glyphs = {
              folder = icons.nvim_tree.folder,
            },
          },
          special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'go.mod' },
        },
      })
    end,
  },
}
