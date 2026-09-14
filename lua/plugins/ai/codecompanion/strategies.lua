-- local defaultAdapter = os.getenv('NVIM_AI_ADAPTER') or 'copilot'
local DEFAULT_ADAPTER = 'openrouter_background'
local DEFAULT_MODEL = 'openai/gpt-oss-120b'
-- local COPILOT_GPTMODEL = 'gpt-4.1'

--------------------------------------------------------------------------------
--                                                                            --
--  CodeCompanion Strategies Configuration                                    --
--                                                                            --
--  Strategies define how CodeCompanion interacts with different contexts and --
--  how one interacts with CodeCompanion.                                     --
--    - Inline: Direct code modifications within the editor                   --
--    - Chat: Conversational interface with context and tools                 --
--    - Command: Command-line style interactions for quick tasks              --
--                                                                            --
--  This module configures adapters, keymaps, slash commands, and tools       --
--  for each strategy.                                                        --
--                                                                            --
--------------------------------------------------------------------------------

local M = {}

----------------
-- Background --
----------------

M.background = {
  -- adapter = {
  --   name = DEFAULT_ADAPTER,
  --   model = 'gpt-5-mini',
  -- },
  chat = {
    callbacks = {
      ['on_ready'] = {
        actions = {
          {
            path = 'interactions.background.builtin.chat_make_title',
            adapter = {
              name = DEFAULT_ADAPTER,
              model = DEFAULT_MODEL,
            },
          },
        },
        enabled = true,
      },
    },
    opts = {
      enabled = true,
    },
  },
  gates = {
    judge = {
      enabled = true,
      adapter = {
        name = DEFAULT_ADAPTER,
        model = DEFAULT_MODEL,
      },
    },
  },
}

M.skills = {
  dirs = {
    '~/.agents/skills', -- Shared agent skills (source of the ~/.claude/skills symlinks)
    '~/.claude/skills', -- Claude Code's personal skills
    '.claude/skills', -- Claude Code's project skills
  },
  opts = {
    chat = {
      enabled = true,
    },
  },
}

--------------
--  Inline  --
--------------

M.inline = {
  adapter = { name = 'openai', model = 'gpt-5.6-luna' },
  opts = {
    diff_timeout = 300,
  },
  variables = require('plugins.ai.codecompanion.variables'),
}

------------
--  Chat  --
------------

-- local extras = [[
--   When replying with code, the code must:
-- - Follow idiomatic patterns and current best practices for the language/framework
-- - Prefer functional programming patterns: small typed functions, currying/partial application
-- - Favor composition over inheritance, explicit over implicit
-- - Functions under 20 lines, max 3 levels nesting
-- - Extract complex logic into focused helper functions
-- - Early returns to reduce nesting
-- - Use current, well-maintained libraries and avoid deprecated patterns
-- - Use descriptive variable names and small named functions to make code read like English
-- - Minimal comments, only when non-idiomatic patterns are used and explanation is needed
--
-- Extra information:
-- - current project that you're working on: %s
-- - current operating system: %s
-- ]]

M.chat = {
  adapter = 'codex',
  -- adapter = 'claude_code',
  -- adapter = {
  --   -- name = DEFAULT_ADAPTER,
  --   -- model = 'gpt-5-mini', -- 'claude-sonnet-4.6',
  --   -- adapter = 'claude_code',
  --   -- model = 'haiku',
  -- },
  sessions = {
    enabled = true,
    autosave = true,
    continuous_save = true,
    save_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'codecompanion', 'sessions'),
  },
  opts = {
    completion_provider = 'blink', -- blink | cmp | coc | default
    -- remove default system prompt for acp agents (these usually come with their
    -- own, and modifying e.g. AGENTS.md is usually better than system prompt)
    system_prompt = function(ctx)
      if ctx.adapter and ctx.adapter.type == 'acp' then
        return ''
      end
      return ctx.default_system_prompt
    end,
    -- system_prompt = function(ctx)
    --   return ctx.default_system_prompt .. string.format(extras, ctx.project_root or ctx.cwd, ctx.os or 'unknown')
    -- end,
    send_code = true,
  },
  roles = {
    llm = function(adapter)
      if adapter.model then
        return string.format('%s (%s)', adapter.formatted_name, adapter.model.name)
      else
        return adapter.formatted_name
      end
    end,
    user = ' Jarmex',
  },
  tools = require('plugins.ai.codecompanion.tools'),
  slash_commands = require('plugins.ai.codecompanion.slash_commands'),
  editor_context = require('plugins.ai.codecompanion.variables'),
  keymaps = {
    close = { modes = { n = 'q', i = '<C-c>' } },
    -- clear = { modes = { n = '<C-x>' } },
    completion = { modes = { i = '<C-x>' } },
    clear = { modes = { n = 'gcr' } },
    regenerate = { modes = { n = 'gcR' } },
  },
  window = {
    breakindent = true,
    cursorcolumn = false,
    cursorline = false,
    spell = false,
    wrap = true,
  },
}

---------------
--  Command  --
---------------

M.cmd = {
  adapter = { name = DEFAULT_ADAPTER, model = DEFAULT_MODEL },
}

M.code_review = {
  enabled = true,
  display = {
    virtual_text = {
      icon = '  ',
      overflow = 'wrap',
    },
  },
}

M.cli = {
  agent = 'claude_code',
  agents = {
    claude_code = {
      cmd = 'claude',
      args = {},
      description = 'Claude Code CLI',
      provider = 'terminal',
    },
    codex = {
      cmd = 'codex',
      args = {},
      description = 'OpenAI Codex CLI',
      provider = 'terminal',
    },
    opencode = {
      cmd = 'opencode',
      args = {},
      description = 'OpenCode',
      provider = 'terminal',
    },
  },
  opts = {
    auto_insert = true, -- Enter insert mode when focusing the CLI terminal
    reload = true, -- Reload buffers when an agent modifies files on disk
  },
}

return M
