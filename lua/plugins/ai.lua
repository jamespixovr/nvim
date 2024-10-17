local function gen_ai_keymaps()
  return {
    { '<leader>ia', mode = { 'n', 'v' }, '<cmd>Gen Ask<cr>', desc = 'A[I] [A]sk' },
    { '<leader>ig', mode = { 'n', 'v' }, '<cmd>Gen<cr>', desc = 'A[I] [G]en' },
    { '<leader>ic', mode = { 'n', 'v' }, '<cmd>Gen Change<cr>', desc = 'A[I] [C]hange' },
    { '<leader>io', mode = { 'n', 'v' }, '<cmd>Gen Change_Code<cr>', desc = 'A[I] Change C[o]de' },
    { '<leader>ih', mode = { 'n', 'v' }, '<cmd>Gen Chat<cr>', desc = 'A[I] C[h]at' },
    { '<leader>ie', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Code<cr>', desc = 'A[I] [E]nhance code' },
    { '<leader>iw', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Wording<cr>', desc = 'A[I] Enhance [W]ording' },
    { '<leader>is', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Grammar_Spelling<cr>', desc = 'A[I] Enhance [G]rammar' },
    { '<leader>it', mode = { 'n', 'v' }, '<cmd>Gen Generate<cr>', desc = 'A[I] Genera[t]e' },
    { '<leader>ir', mode = { 'n', 'v' }, '<cmd>Gen Review_Code<cr>', desc = 'A[I] [R]eview Code' },
    { '<leader>iz', mode = { 'n', 'v' }, '<cmd>Gen Summarize<cr>', desc = 'A[I] Summari[z]e' },
  }
end

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

  {
    'David-Kunz/gen.nvim',
    enabled = false,
    cmd = { 'Gen' },
    event = 'VeryLazy',
    keys = gen_ai_keymaps(),
    opts = {
      model = 'mistral', -- The default model to use.
      display_mode = 'split', -- The display mode. Can be "float" or "split".
      debug = false, -- Prints errors and the command which is run.
      show_prompt = true, -- Shows the Prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = true, -- Never closes the window automatically.
    },
    config = function(_, opts)
      require('gen').setup(opts)
      require('gen').prompts['Fix_Code'] = {
        prompt = 'Fix the following code. Only output the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```',
        replace = true,
        extract = '```$filetype\n(.-)```',
      }
    end,
  },
}
