return function()
  return {
    {
      '<leader>.',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Scratch Buffer',
    },
    {
      '<leader>st',
      function()
        Snacks.scratch({ icon = ' ', name = 'Todo', ft = 'markdown', file = 'scratch-file.md' })
      end,
      desc = 'Todo List',
    },
    {
      '<leader>S',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Buffer',
    },
    {
      '<leader>ns',
      function()
        Snacks.notifier.show_history()
      end,
      desc = 'Notification History',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>gB',
      function()
        Snacks.gitbrowse()
      end,
      desc = 'Git Browse',
    },
    {
      '<leader>gb',
      function()
        Snacks.git.blame_line()
      end,
      desc = 'Git Blame Line',
    },
    {
      '<leader>gf',
      function()
        Snacks.lazygit.log_file()
      end,
      desc = 'Lazygit Current File History',
    },
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'Lazygit',
    },
    {
      '<leader>gl',
      function()
        Snacks.lazygit.log()
      end,
      desc = 'Lazygit Log (cwd)',
    },
    {
      '<leader>un',
      function()
        Snacks.notifier.hide()
      end,
      desc = 'Dismiss All Notifications',
    },
    -- { "<c-i>",     function() Snacks.terminal() end, desc = "Toggle Terminal" },
    {
      'TT',
      function()
        Snacks.terminal()
      end,
      desc = 'Toggle Terminal',
    },
    {
      ']]',
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = 'Next Reference',
      mode = { 'n', 't' },
    },
    {
      '[[',
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = 'Prev Reference',
      mode = { 'n', 't' },
    },
    {
      '<leader>jg',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>/',
      function()
        Snacks.picker.grep()
      end,
      desc = 'Grep',
    },
    {
      '<leader>sb',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sh',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>sk',
      function()
        Snacks.picker.keymaps()
      end,
      desc = 'Keymaps',
    },
    {
      '<leader>rr',
      function()
        Snacks.picker.resume()
      end,
      desc = 'Resume',
    },
    {
      '<leader>jf',
      function()
        Snacks.picker.files()
      end,
      desc = 'Find Files',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.commands()
      end,
      desc = 'Commands',
    },
    {
      '<leader>je',
      function()
        Snacks.picker.explorer()
      end,
      desc = 'Commands',
    },
    {
      '<leader>ff',
      function()
        Snacks.picker.smart({ filter = { cwd = true } })
      end,
      desc = 'Find Files',
    },
    {
      '<leader>bb',
      function()
        Snacks.picker.buffers({ layout = { preset = 'select' } })
      end,
      desc = 'Buffers',
    },
    {
      '<leader>sp',
      function()
        Snacks.picker({ layout = { preset = 'vscode' } })
      end,
      desc = 'Pickers',
    },
    {
      '<leader>ld',
      function()
        Snacks.picker.lsp_definitions():set_layout('vertical')
      end,
      desc = 'Definition',
    },
    {
      '<leader>lr',
      function()
        Snacks.picker.lsp_references():set_layout('mivy')
      end,
      nowait = true,
      desc = 'References',
    },
    {
      '<leader>lI',
      function()
        Snacks.picker.lsp_implementations():set_layout('mivy')
      end,
      desc = 'Implementation',
    },
    {
      '<leader>lt',
      function()
        Snacks.picker.lsp_type_definitions():set_layout('mivy')
      end,
      desc = 'Type Definition',
    },
    {
      '<leader>:',
      function()
        Snacks.picker.command_history()
      end,
      desc = 'Command History',
    },
    -- Grep
    {
      '<leader>sb',
      function()
        Snacks.picker.lines()
      end,
      desc = 'Buffer Lines',
    },
    {
      '<leader>sB',
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = 'Grep Open Buffers',
    },
    {
      '<leader>sw',
      function()
        Snacks.picker.grep_word()
      end,
      desc = 'Visual selection or word',
      mode = { 'n', 'x' },
    },
    {
      '<leader>s/',
      function()
        Snacks.picker.search_history()
      end,
      desc = 'Search History',
    },
    {
      '<leader>sm',
      function()
        Snacks.picker.marks()
      end,
      desc = 'Marks',
    },
  }
end
