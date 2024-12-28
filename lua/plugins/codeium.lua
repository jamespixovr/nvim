local function codeium_keymaps()
  local function local_map(key, func, desc, mode)
    if not mode then
      mode = 'i'
    end
    return { key, func, mode = mode, expr = true, silent = true, desc = desc }
  end
  return {
		-- stylua: ignore start
    local_map("<C-cr>", function() return vim.fn["codeium#Accept"]() end, "󰚩 Accept Suggestion"),
    local_map("<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, "󰚩 Cycle Suggestion"),
    local_map("<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, "󰚩 Cycle Suggestion"),
    local_map("<c-x>", function() return vim.fn["codeium#Clear"]() end, "󰚩 Clear Suggestion"),
    local_map("<leader>cd", function() return vim.fn["codeium#Chat"]() end, "󰚩 Chat", "n"),
    -- stylua: ignore end
  }
end
return {
  {
    'Exafunction/codeium.vim',
    event = 'InsertEnter',
    keys = codeium_keymaps(),
    config = function()
      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        DressingInput = false,
      }
      vim.g.codeium_disable_bindings = 1
    end,
  },
}
