return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    build = ':Copilot auth',
    -- event = 'InsertEnter',
    keys = {
      -- { mode = { 'n' }, '<leader>ce', ':Copilot enable<CR>', { silent = true } },
      -- { mode = { 'n' }, '<leader>cd', ':Copilot disable<CR>', { silent = true } },
      -- { mode = { 'n' }, '<leader>cp', ':Copilot panel<CR>', { silent = true } },
    },
    config = function()
      require('plugins.ai.copilot').setup({
        -- panel = {
        --   enabled = false,
        -- },
        suggestion = {
          enabled = false,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = '<C-y><C-y>',
            accept_word = '<C-y><C-w>',
            accept_line = '<C-y><C-l>',
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
      })
    end,
  },
}
