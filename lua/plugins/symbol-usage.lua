return {
  { -- CodeLens, but also for languages not supporting it
    'Wansmer/symbol-usage.nvim',
    event = 'LspAttach',
    opts = {
      request_pending_text = false, -- remove "loading…"
      references = { enabled = true, include_declaration = false },
      definition = { enabled = false },
      implementation = { enabled = false },
      vt_position = 'end_of_line',
      vt_priority = nil, -- below the gitsigns default of 6
      hl = { link = 'Comment' },
    },
  },
}
