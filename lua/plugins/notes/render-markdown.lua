return {
  ---@module "lazy.types"
  ---@type LazyPluginSpec
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'codecompanion', 'obsidian', 'copilot-chat', 'codecompanion_chat_input' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      code = { sign = false, border = 'thin' },
      win_options = {
        concealcursor = {
          rendered = 'n',
        },
      },
      -- Normal mode maintains the preview effect, preventing the raw Markdown symbols from appearing on the line where the cursor is located.
      anti_conceal = {
        enabled = true,
        disabled_modes = { 'n' },
        above = 0,
        below = 0,
      },
      completions = {
        blink = { enabled = true },
        lsp = { enabled = false },
      },
      debounce = 250,
      file_types = {
        'markdown',
        'markdown.floaterm',
        'codecompanion',
        'obsidian',
        'codecompanion.floaterm',
      },
      latex = { enabled = false, render_modes = false },
      render_modes = true, -- Render in ALL modes
      sign = {
        enabled = false, -- Turn off in the status column
      },
      checkbox = {
        enabled = true,
        -- unchecked = { icon = '󱍫', highlight = 'DiagnosticInfo' },
        -- checked = { icon = '󱍧', highlight = 'DiagnosticOk' },

        checked = { icon = '󰄵', highlight = 'DiagnosticInfo' },
        unchecked = { icon = '󰄱', highlight = 'DiagnosticOk' },
        custom = {
          in_progress = { raw = '[+]', rendered = '󱍬', highlight = 'DiagnosticInfo' },
          wont_do = { raw = '[/]', rendered = '󱍮', highlight = 'DiagnosticError' },
          waiting = { raw = '[?]', rendered = '󱍥', highlight = 'DiagnosticWarn' },
          -- todo = { rendered = '◯ ' },
          todo = { rendered = '󰡖', raw = '[-]', highlight = 'RenderMarkdownInfo' },
        },
      },
      pipe_table = {
        border_enabled = true,
        border_virtual = true, -- borders not on empty lines -> preserves blank lines
      },
      heading = {
        sign = false,
        position = 'inline', -- = remove indentation of headings
        width = 'block', -- = not full width
        min_width = vim.o.textwidth,
        icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' }, -- `numeric_x` glyphs
        -- icons = { "󰲠 ", "󰲢 ", "󰲤 ", "󰲦 ", "󰲨 ", "󰲪 " },
        -- icons = {
        --   '█ ',
        --   '██ ',
        --   '███ ',
        --   '████ ',
        --   '█████ ',
        --   '██████ ',
        --   '███████ ',
        -- },
        right_pad = 1,
        border_prefix = true,
        border = false,
      },
      dash = {
        width = vim.o.textwidth,
        priority = 10, -- don't cover codelens from `markdown-oxide` for 1st line of frontmatter
      },
      -- bullet = {
      --   icons = { '◇', '◆', '▫️' }, -- ◆◇•◦▫️▪️
      --   ordered_icons = '', -- disable overwriting ordered list numbers with 1-2-3
      -- },
      html = {
        enabled = true,
        comment = {
          text = function(ctx)
            local text = ctx.text:match('^<!%-%-%s*(.-)%s*%-%->$')
            if not text then
              return ''
            end
            return '󰆈 ' .. text:gsub('\n.*', '…')
          end,
        },
        tag = {
          buf = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          file = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          -- help = { icon = '󰘥 ', highlight = 'CodeCompanionChatVariable' },
          -- help = { icon = '󰾚 ', highlight = 'CodeCompanionChatVariable' },
          image = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          symbols = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          url = { icon = '󰖟 ', highlight = 'CodeCompanionChatVariable' },
          var = { icon = ' ', highlight = 'CodeCompanionChatVariable' },
          tool = { icon = ' ', highlight = 'CodeCompanionChatTool' },
          user = { icon = ' ', highlight = 'CodeCompanionChatTool' },
          group = { icon = ' ', highlight = 'CodeCompanionChatToolGroup' },
          memory = { icon = '󰍛 ', highlight = 'CodeCompanionChatVariable' },
          help = { icon = '󰱼 ', highlight = 'CodeCompanionChatVariable' },
          rules = { icon = '󰺾 ', highlight = 'CodeCompanionChatVariable' },
        },
      },
      overrides = {
        buftype = {
          nofile = {
            render_modes = true,
            sign = { enabled = false },
            padding = { highlight = 'NormalFloat' },
            code = { border = 'hide', style = 'normal' },
          },
        },
      },
      restart_highlighter = false,
    },
  },
}
