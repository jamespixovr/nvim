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

  {
    "piersolenski/wtf.nvim",
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
    opts = {
      model = "mistral",        -- The default model to use.
      display_mode = "float",   -- The display mode. Can be "float" or "split".
      show_prompt = false,      -- Shows the Prompt submitted to Ollama.
      show_model = false,       -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false,    -- Never closes the window automatically.
      init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
      -- Function to initialize Ollama
      command = "curl --silent --no-buffer -X POST http://localhost:11434/api/generate -d $body",
      -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
      -- This can also be a lua function returning a command string, with options as the input parameter.
      -- The executed command must return a JSON object with { response, context }
      -- (context property is optional).
      list_models = '<function>',   -- Retrieves a list of model names
      debug = false                 -- Prints errors and the command which is run.
    }
  }
}
