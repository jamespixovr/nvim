return {
  -- codeium
  {
    "Exafunction/codeium.vim",
    event = 'InsertEnter',
    keys = {
      {
        "<C-cr>",
        function() return vim.fn["codeium#Accept"]() end,
        mode = "i",
        expr = true,
        silent = true,
        desc = "󰚩 Accept Suggestion",
      },
      {
        "<c-;>",
        function() return vim.fn["codeium#CycleCompletions"](1) end,
        mode = "i",
        expr = true,
        silent = true,
        desc = "󰚩 Cycle Suggestion",
      },
      {
        "<c-,>",
        function() return vim.fn["codeium#CycleCompletions"](-1) end,
        mode = "i",
        expr = true,
        silent = true,
        desc = "󰚩 Cycle Suggestion",
      },
      {
        "<c-x>",
        function() return vim.fn["codeium#Clear"]() end,
        mode = "i",
        expr = true,
        silent = true,
        desc = "󰚩 Clear Suggestion",
      }
    },
    config = function()
      vim.g.codeium_filetypes = {
        TelescopePrompt = false,
        DressingInput = false,
      }
      vim.g.codeium_disable_bindings = 1
    end
  },
}