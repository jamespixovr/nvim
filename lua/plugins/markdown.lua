return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'markdown', 'codecompanion' },
    opts = {
      file_types = { 'markdown', 'codecompanion' },
      latex = { enabled = false },
      render_modes = true, -- Render in ALL modes
      -- render_modes = { 'n', 'c', 'i' },
      sign = {
        enabled = false, -- Turn off in the status column
        exclude = {
          buftypes = { 'nofile' },
        },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = '󱍫', highlight = 'DiagnosticInfo' },
        checked = { icon = '󱍧', highlight = 'DiagnosticOk' },
        custom = {
          in_progress = { raw = '[+]', rendered = '󱍬', highlight = 'DiagnosticInfo' },
          wont_do = { raw = '[/]', rendered = '󱍮', highlight = 'DiagnosticError' },
          waiting = { raw = '[?]', rendered = '󱍥', highlight = 'DiagnosticWarn' },
        },
      },
    },
  },
}
