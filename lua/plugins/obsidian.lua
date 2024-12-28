return {
  'epwalsh/obsidian.nvim',
  enabled = true,
  version = '*',
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- "preservim/vim-markdown",
  },
  -- event = {
  --   "BufReadPre " .. vim.fn.expand("~") .. "/c/second-brain/**.md",
  --   "BufNewFile " .. vim.fn.expand("~") .. "/c/second-brain/**.md",
  -- },
  cmd = {
    'ObsidianOpen',
    'ObsidianNew',
    'ObsidianQuickSwitch',
    'ObsidianFollowLink',
    'ObsidianBacklinks',
    'ObsidianToday',
    'ObsidianYesterday',
    'ObsidianTemplate',
    'ObsidianSearch',
    'ObsidianLink',
    'ObsidianLinkNew',
  },

  opts = {
    workspaces = {
      {
        name = 'personal',
        path = '~/vaults/jamesamo',
      },
      {
        name = 'work',
        path = '~/vaults/work',
      },
    },
    completion = {
      nvim_cmp = vim.g.cmploader == 'nvim-cmp',
      -- Trigger completion at 2 chars.
      min_chars = 2,
    },

    daily_notes = {
      folder = 'Periodic 🌄/Days 🌄',
      -- Optional, if you want to change the date format for the ID of daily notes.
      -- date_format = "%Y-%m-%d",
      -- Optional, if you want to change the date format of the default alias of daily notes.
      -- alias_format = "%B %-d, %Y",
    },

    notes_subdir = 'inbox',
    new_notes_location = 'notes_subdir',
    disable_frontmatter = true,

    -- Optional, for templates (see below).
    templates = {
      subdir = 'templates',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
    },

    follow_url_func = function(url)
      vim.fn.jobstart({ 'open', url })
    end,

    -- Optional, set to true if you use the Obsidian Advanced URI plugin.
    -- https://github.com/Vinzent03/obsidian-advanced-uri
    use_advanced_uri = true,

    -- Optional, set to true to force ':ObsidianOpen' to bring the app to the foreground.
    open_app_foreground = true,
    ui = {
      enable = false, -- set to false to disable all additional syntax features
      update_debounce = 200, -- update delay after a text change (in milliseconds)
      -- Define how various check-boxes are displayed
      checkboxes = {
        -- NOTE: the 'char' value has to be a single character, and the highlight groups are defined below.
        -- [' '] = { char = '󰄱', hl_group = 'ObsidianTodo' },
        -- ['x'] = { char = '', hl_group = 'ObsidianDone' },
        -- ['>'] = { char = '', hl_group = 'ObsidianRightArrow' },
        -- ['~'] = { char = '󰰱', hl_group = 'ObsidianTilde' },
        -- Replace the above with this if you don't have a patched font:
        -- [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        -- ["x"] = { char = "✔", hl_group = "ObsidianDone" },

        -- You can also add more custom ones...
      },
      bullets = {},
      external_link_icon = { char = '', hl_group = 'ObsidianExtLinkIcon' },
      -- Replace the above with this if you don't have a patched font:
      -- external_link_icon = { char = "", hl_group = "ObsidianExtLinkIcon" },
      reference_text = { hl_group = 'ObsidianRefText' },
      highlight_text = { hl_group = 'ObsidianHighlightText' },
      tags = { hl_group = 'ObsidianTag' },
      hl_groups = {
        -- The options are passed directly to `vim.api.nvim_set_hl()`. See `:help nvim_set_hl`.
        ObsidianTodo = { bold = true, fg = '#f78c6c' },
        ObsidianDone = { bold = true, fg = '#89ddff' },
        ObsidianRightArrow = { bold = true, fg = '#f78c6c' },
        ObsidianTilde = { bold = true, fg = '#ff5370' },
        ObsidianRefText = { underline = true, fg = '#c792ea' },
        ObsidianExtLinkIcon = { fg = '#c792ea' },
        ObsidianTag = { italic = true, fg = '#89ddff' },
        ObsidianHighlightText = { bg = '#75662e' },
      },
    },
    mappings = {
      -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
      -- Toggle check-boxes.
      ['<leader>ch'] = {
        action = function()
          return require('obsidian').util.toggle_checkbox()
        end,
        opts = { buffer = true },
      },
      -- Smart action depending on context, either follow link or toggle checkbox.
      ['<cr>'] = {
        action = function()
          return require('obsidian').util.smart_action()
        end,
        opts = { buffer = true, expr = true },
      },
    },
  },

  keys = {
    { '<leader>oo', ':cd /Users/jamesamo/vaults<cr>', desc = 'Open parent directory' },
    { '<leader>on', ':ObsidianTemplate note<cr> :lua vim.cmd([[1,/^\\S/s/^\\n\\{1,}//]])<cr>', desc = 'New Note' },
    -- { '<leader>of', ':s/\\(# \\)[^_]*_/\\1/ | s/-/ /g<cr>', desc = 'Fix Headers' },
    { '<leader>no', '<cmd>ObsidianOpen<cr>', desc = 'Open Obsidian' },
    { '<leader>nn', '<cmd>ObsidianNew<cr>', desc = 'New note' },
    { '<leader>of', '<cmd>ObsidianSearch<cr>', desc = 'Search notes' },
    -- { '<leader>nt', '<cmd>ObsidianTags<cr>', desc = 'List notes by tags' },
    -- { '<leader>nq', '<cmd>ObsidianQuickSwitch<cr>', desc = 'Quick switch in obsidian workspace' },
    -- { '<leader>nw', '<cmd>ObsidianWorkspace work<cr>', desc = 'Change to workspace work in obsidian' },
    -- { '<leader>np', '<cmd>ObsidianWorkspace personal<cr>', desc = 'Change to workspace home in obsidian' },
  },

  config = function(_, opts)
    require('obsidian').setup(opts)
    vim.keymap.set('n', 'gd', function()
      if require('obsidian').util.cursor_on_markdown_link() then
        return '<cmd>ObsidianFollowLink<CR>'
      else
        return 'gd'
      end
    end, { noremap = false, expr = true })
  end,
}
