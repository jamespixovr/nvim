return {
  {
    'olimorris/codecompanion.nvim',
    version = false,
    dependencies = {
      'hakonharnes/img-clip.nvim',
      'jarmex/codecompanion-gitcommit.nvim',
    },
    cmd = {
      'CodeCompanionChat',
      'CodeCompanion',
      'CodeCompanionCmd',
      'CodeCompanionActions',
      'CodeCompanionHistory',
    },
    event = 'VeryLazy',
    keys = require('plugins.ai.codecompanion.keymaps'),
    opts = function()
      local adapters = require('plugins.ai.codecompanion.adapters')
      local display = require('plugins.ai.codecompanion.display')
      local strategies = require('plugins.ai.codecompanion.strategies')

      return {
        adapters = adapters,
        interactions = {
          inline = strategies.inline,
          cmd = strategies.cmd,
          chat = strategies.chat,
          background = strategies.background,
          cli = strategies.cli,
          code_review = strategies.code_review,
        },
        display = {
          diff = display.diff,
          inline = { diff = { enabled = true } },
          chat = display.chat,
          action_palette = display.action_palette,
        },
        prompt_library = require('plugins.ai.codecompanion.promptlibrary'),
        extensions = require('plugins.ai.codecompanion.extensions'),
        mcp = require('plugins.ai.codecompanion.mcp').mcpServers,
        skills = strategies.skills,
        opts = {
          log_level = 'DEBUG',
        },
        rules = {
          claude = {
            parser = 'claude',
            description = 'Rule files for claude',
            files = {
              { path = 'CLAUDE.md', parser = 'claude' },
              { path = 'CLAUDE.local.md', parser = 'claude' },
              { path = '~/.claude/CLAUDE.md', parser = 'claude' },
            },
            is_preset = true,
          },
          programming = {
            description = 'Personal rules and code philosophy',
            files = {
              vim.fn.stdpath('config') .. '/prompts/personal-programming.md',
              os.getenv('HOME') .. '/.agent/AGENTS.md',
              { path = '~/.config/personal/PERSONAL.md', parser = 'codecompanion' },
              { path = 'CLAUDE.md', parser = 'claude' },
              { path = 'AGENTS.md', parser = 'claude' },
            },
          },
          personal = {
            description = 'Personal rules and code philosophy',
            files = {
              { path = '~/.config/personal/PERSONAL.md', parser = 'codecompanion' },
            },
          },
          opts = {
            chat = {
              autoload = { 'personal' },
              autoload_groups_in_prompt_library = true,
              -- autoload = 'default',
              enabled = true,
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require('codecompanion').setup(opts)
      -- Expand `cc` into CodeCompanion in the command line
      vim.cmd([[cab cc CodeCompanion]])

      -- require('plugins.ai.codecompanion.spinner'):init()
      -- Ensure buffer is treated as markdown by treesitter despite being codecompanion filetype
      vim.treesitter.language.register('markdown', 'codecompanion')

      -- Emit CodeCompanion title to CodeCompanionHistory
      vim.api.nvim_create_autocmd('User', {
        pattern = 'CodeCompanionChatSubmitted',
        callback = function(ev)
          local ok, chat_mod = pcall(require, 'codecompanion.interactions.chat')
          if not ok then
            return
          end

          local chat = chat_mod.buf_get_chat(ev.data.bufnr)
          if chat and chat.title and chat.title ~= '' then
            chat.opts.title = chat.title
          end
        end,
      })

      require('plugins.ai.codecompanion.spinner').codecompanion_snacks()
    end,
  },
}
