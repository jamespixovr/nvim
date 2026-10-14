return {
  'HakonHarnes/img-clip.nvim',
  enabled = true,
  event = 'VeryLazy',
  cmd = { 'PasteImage' },
  opts = {
    default = {
      dir_path = 'assets/images',
      prompt_for_file_name = false,
      show_dir_path_in_prompt = true,
    },
    filetypes = {
      codecompanion = {
        prompt_for_file_name = false,
        template = '[Image]($FILE_PATH)',
        use_absolute_path = true,
      },
      markdown = {
        relative_to_current_file = true,
        prompt_for_file_name = false,
        template = '![$CURSOR]($FILE_PATH)',
        dir_path = 'assets/images',
      },
    },
  },
  keys = {
    -- suggested keymap
    { '<leader>zp', '<cmd>PasteImage<cr>', desc = 'Paste image from system clipboard' },
    {
      '<leader>#',
      function()
        Snacks.picker.files({
          ft = { 'jpg', 'jpeg', 'png', 'webp' },
          confirm = function(self, item, _)
            self:close()
            require('img-clip').paste_image({}, './' .. item.file) -- ./ is necessary for img-clip to recognize it as path
          end,
        })
      end,
      desc = 'Image',
    },
  },
}
