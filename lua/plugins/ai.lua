return {
  {
    'Exafunction/codeium.vim',
    event = 'InsertEnter',
    keys = require('config.keymaps').codeium_keymaps(),
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
    cmd = { 'Gen' },
    event = 'VeryLazy',
    keys = require('config.keymaps').gen_ai_keymaps(),
    opts = {
      model = 'codegeex4', -- The default model to use.
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
