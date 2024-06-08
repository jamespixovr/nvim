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
      },
      {
        "<leader>cd",
        function() return vim.fn["codeium#Chat"]() end,
        mode = "n",
        expr = true,
        silent = true,
        desc = "󰚩 Chat",
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

  {
    "jarmex/wtf.nvim",
    branch = "ollama-zephyr",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = {
      {
        "gw",
        mode = { "n", "x" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        "gW",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    }
  },
  {
    "David-Kunz/gen.nvim",
    keys = {
      { '<leader>ia', mode = { "n", "v" }, "<cmd>Gen Ask<cr>",                      desc = "A[I] [A]sk" },
      { '<leader>ig', mode = { "n", "v" }, "<cmd>Gen<cr>",                          desc = "A[I] [G]en" },
      { '<leader>ic', mode = { "n", "v" }, "<cmd>Gen Change<cr>",                   desc = "A[I] [C]hange" },
      { '<leader>io', mode = { "n", "v" }, "<cmd>Gen Change_Code<cr>",              desc = "A[I] Change C[o]de" },
      { '<leader>ih', mode = { "n", "v" }, "<cmd>Gen Chat<cr>",                     desc = "A[I] C[h]at" },
      { '<leader>ie', mode = { "n", "v" }, "<cmd>Gen Enhance_Code<cr>",             desc = "A[I] [E]nhance code" },
      { '<leader>iw', mode = { "n", "v" }, "<cmd>Gen Enhance_Wording<cr>",          desc = "A[I] Enhance [W]ording" },
      { '<leader>is', mode = { "n", "v" }, "<cmd>Gen Enhance_Grammar_Spelling<cr>", desc = "A[I] Enhance [G]rammar" },
      { '<leader>it', mode = { "n", "v" }, "<cmd>Gen Generate<cr>",                 desc = "A[I] Genera[t]e" },
      { '<leader>ir', mode = { "n", "v" }, "<cmd>Gen Review_Code<cr>",              desc = "A[I] [R]eview Code" },
      { '<leader>iz', mode = { "n", "v" }, "<cmd>Gen Summarize<cr>",                desc = "A[I] Summari[z]e" },
    },
    opts = {
      model = "llama3",       -- The default model to use.
      display_mode = "split", -- The display mode. Can be "float" or "split".
      debug = false,          -- Prints errors and the command which is run.
      show_prompt = true,     -- Shows the Prompt submitted to Ollama.
      show_model = true,      -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = true,   -- Never closes the window automatically.
    },
    config = function(_, opts)
      require("gen").setup(opts)
      require("gen").prompts["Fix_Code"] = {
        prompt =
        "Fix the following code. Only ouput the result in format ```$filetype\n...\n```:\n```$filetype\n$text\n```",
        replace = true,
        extract = "```$filetype\n(.-)```",
      }
    end
  }
}
