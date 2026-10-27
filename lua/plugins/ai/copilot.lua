return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    build = ':Copilot auth',
    dependencies = {
      'copilotlsp-nvim/copilot-lsp',
    },
    opts = {
      -- copilot_node_command = {"mise", "x", "node@lts", "--", "node" },
      panel = { enabled = false },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = 'off' },
          advanced = { inlineSuggestCount = 3 },
        },
      },
      -- copilot_model = 'gpt-41-copilot',
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = {
          accept = '<c-;>',
          accept_word = '<c-o>',
          accept_line = '<c-l>',
          next = '<c-.>',
          prev = '<c-,>',
          dismiss = "<c-'>",
        },
      },
      nes = {
        enabled = false,
        auto_trigger = true,
        keymap = {
          -- accept_and_goto = false,
          -- accept = "<leader>p",
          accept_and_goto = '<leader>p',
          accept = false,
          dismiss = '<Esc>',
        },
      },
      filetypes = {
        ['*'] = true,
      },
    },
  },
}
