return {
  'stevearc/oil.nvim',
  keys = {
    { '<leader>-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
  },
  opts = {
    default_file_explorer = true,
    keymaps = {
      ['<C-v>'] = 'actions.select_vsplit',
      ['<C-x>'] = 'actions.select_split',
      ['g?'] = 'actions.show_help',
      ['<CR>'] = 'actions.select',
      ['<C-t>'] = { 'actions.select', opts = { tab = true }, desc = 'Open the entry in new tab' },
      ['<C-p>'] = 'actions.preview',
      ['<C-c>'] = 'actions.close',
      ['<C-l>'] = false,
      ['<C-h>'] = false,
      ['<C-s>'] = false,
      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',
      ['`'] = 'actions.cd',
      ['gs'] = 'actions.change_sort',
      ['gx'] = 'actions.open_external',
      ['g.'] = 'actions.toggle_hidden',
      ['g\\'] = 'actions.toggle_trash',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    preview = { border = vim.g.borderStyle },
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name)
        return name == '..' or name == '.git'
      end,
    },
    win_options = {
      wrap = true,
    },
  },
}
