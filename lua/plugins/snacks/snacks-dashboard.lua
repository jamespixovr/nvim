return {
  'folke/snacks.nvim',
  opts = {
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          {
            icon = ' ',
            key = 'f',
            desc = 'Find File',
            action = ':lua Snacks.picker.smart({filter = {cwd = true}})',
          },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 's', desc = 'Load Session', section = 'session' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = '󱘣 ', key = '/', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = ' ', key = 'm', desc = 'Show mark', action = ":lua Snacks.dashboard.pick('marks')" },
          { icon = ' ', key = 't', desc = 'Show todo', action = ':TodoQuickFix' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy', enabled = package.loaded.lazy ~= nil },
          {
            icon = '󱕻',
            key = 'T',
            desc = "Today's Daily Note",
            action = ':ObsidianToday',
          },
          {
            icon = '󰭹 ',
            key = 'a',
            desc = 'AI Chat',
            action = function()
              require('codecompanion').chat()
            end,
          },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        {
          section = 'terminal',
          cmd = 'lolcat --seed=24 ~/.config/nvim/static/neo2.cat',
          indent = -5,
          height = 10,
          width = 71,
          padding = 1,
        },
        {
          section = 'keys',
          indent = 1,
          gap = 1,
          padding = 1,
        },
        { section = 'startup' },
      },
    },
  },
}
