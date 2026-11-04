-- CodeCompanion Display Configuration

local M = {}

-- Action Palette

M.action_palette = {
  width = 95,
  height = 20,
  prompt = 'Prompt ',
  provider = 'snacks', -- default|telescope|mini_pick
  opts = {
    show_preset_actions = true,
    show_default_prompt_library = true,
  },
}

-- Diff Provider

M.diff = {
  enabled = false,
  provider = 'inline', -- mini_diff|split|inline
  provider_opts = {
    split = {
      close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
      layout = 'vertical', -- vertical|horizontal split
      opts = {
        'internal',
        'filler',
        'closeoff',
        'algorithm:histogram',
        'indent-heuristic',
        'followwrap',
        'linematch:120',
      },
    },
    inline = {
      layout = 'float', -- float|buffer - Where to display the diff
      show_keymap_hints = true, --
      show_removed = true, --
    },
  },
}

-- Chat Window
M.chat = {
  show_settings = false,
  show_token_count = false,
  show_reasoning = false,
  fold_reasoning = true,
  show_context = true,
  show_tools_processing = true,
  start_in_insert_mode = false,
  auto_scroll = true,
  fold_context = true,
  -- floating_window = { opts = { wrap = true } },
  icons = {
    -- tool_success = '󰸞 ',
    pinned_buffer = ' ',
    watched_buffer = '👀 ',
    chat_context = '📎️',
    sync_all = '󰪴 ',
    sync_diff = ' ',
    -- chat_context = " ",
    chat_fold = ' ',
    tool_pending = '  ',
    tool_in_progress = '  ',
    tool_failure = '  ',
    tool_success = '  ',
  },
  input = {
    layout = 'split', -- Can be "buffer" or "split"
    height = 10, -- lines
    title = 'CodeCompanion.nvim', -- shown in the winbar until the chat has a title
    winbar = true, -- set to false if a plugin manages your winbar
  },
  window = {
    width = 0.60,
    layout = vim.o.columns >= 120 and 'vertical' or 'horizontal',
    full_height = true, -- for vertical layout
    position = 'right', -- left|right|top|bottom (nil will default depending on vim.opt.splitright|vim.opt.splitbelow)
    height = 1.0, ---@return number|fun(): number
    sticky = true,
    opts = {
      number = false,
      relativenumber = false,
      signcolumn = 'no',
      spell = false,
      -- winbar = '',
      nu = false,
      breakindent = true,
      linebreak = true,
    },
  },
}

return M
