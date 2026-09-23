return {
  ['insert_edit_into_file'] = {
    opts = {
      requires_approval_before = {
        buffer = false,
        file = false,
      },
      requires_approval_after = true,
    },
  },
  ['run_command'] = {
    opts = {
      judge_in_yolo_mode = true,
      require_approval_before = false,
      requires_approval_after = false,
    },
  },
  ['fetch_webpage'] = {
    opts = {
      adapter = 'markitdown', -- jina, markitdown
      require_approval_before = false,
    },
  },
  ['web_search'] = {
    opts = {
      -- adapter = 'tavily', -- tavily, duckduckgo
    },
  },
  ['delete_file'] = {
    opts = {
      requires_approval_before = true,
    },
  },
  ['read_file'] = {
    opts = {
      require_approval_before = false,
    },
  },
  ['fetch'] = {
    opts = {
      require_approval_before = false,
    },
  },
  ['file_search'] = {
    opts = {
      require_approval_before = false,
    },
  },
  ['get_changed_files'] = {
    opts = {
      require_approval_before = false,
    },
  },
  ['grep_search'] = {
    -- CodeCompanion copies a tool's whole config onto its chat context item, and
    -- the sessions serializer (vim.json.encode) cannot encode function values.
    -- The default `enabled` is a function (rg presence check); a boolean keeps
    -- sessions saveable while the upstream leak is fixed.
    enabled = true,
    opts = {
      require_approval_before = false,
    },
  },
  ['memory'] = {
    opts = {
      require_approval_before = false,
      whitelist = {
        { path = '~/.config/personal/PERSONAL.md', as = '/personal' },
        { path = '~/vaults/pixovr/notes', as = '/notes' },
      },
    },
  },
  groups = {
    ['mymemory'] = {
      description = 'agent memory access',
      prompt = 'You have access to your ${tools} which contain information about you, your preferences, and your past interactions. Use this information to inform your decisions and actions.',
      tools = {
        'memory',
      },
      opts = {
        collapse_tools = true,
      },
    },
    ['myagent'] = {
      description = 'agent mode with mcp support, automatically run tools',
      -- prompt = "I'm giving you access to the ${tools} to help you perform coding tasks",
      tools = {
        'ask_questions',
        'create_file',
        'file_search',
        'files',
        'get_changed_files',
        'grep_search',
        'insert_edit_into_file',
        'memory',
        'next_edit_suggestion',
        'read_file',
        'run_command',
        'web_search',
      },
      opts = {
        collapse_tools = true,
      },
    },
    ['plan'] = {
      description = 'Software architect agent for exploring and designing implementation plans (read-only)',
      system_prompt = function()
        local plans_dir = vim.fn.expand('~/.local/share/nvim/plans')
        vim.fn.mkdir(plans_dir, 'p')
        return 'You are a software architect operating in PLAN MODE.\n\n'
          .. '=== PLAN MODE RULES ===\n'
          .. 'You must NEVER modify or delete existing project files. You must NEVER run destructive commands.\n'
          .. 'Your ONLY allowed write action is creating the final plan file in: '
          .. plans_dir
          .. '\n'
          .. 'The plan file must be named descriptively based on the task (e.g., `add-auth-middleware.md`, `refactor-data-layer.md`).\n\n'
          .. '=== PROCESS ===\n\n'
          .. '**Phase 1 - Understand**\n'
          .. "- Read the user's request carefully\n"
          .. '- Ask clarifying questions if the request is ambiguous\n'
          .. '- Use file_search and grep_search to locate relevant code\n'
          .. '- Use read_file to examine key files\n\n'
          .. '**Phase 2 - Investigate**\n'
          .. '- Trace through relevant code paths\n'
          .. '- Identify existing patterns, conventions, and abstractions\n'
          .. '- Find similar features as reference implementations\n'
          .. '- Note potential conflicts or dependencies\n\n'
          .. '**Phase 3 - Design**\n'
          .. '- Propose an approach with clear rationale\n'
          .. '- Identify trade-offs and alternatives considered\n'
          .. '- Ask the user for feedback before finalizing\n\n'
          .. '**Phase 4 - Write the Plan**\n'
          .. 'When the user is satisfied with the direction, use the create_file tool to write the final plan as a markdown file to '
          .. plans_dir
          .. '. Use this format:\n\n'
          .. '# <Plan Title>\n\n'
          .. '## Context\n'
          .. '<Why this change is needed and what prompted it>\n\n'
          .. '## Recommended Approach\n'
          .. '<Step-by-step implementation strategy>\n\n'
          .. '## Files to Modify\n'
          .. '- `path/to/file` — <what changes and why>\n\n'
          .. '## Existing Code to Reuse\n'
          .. '- `path/to/file#function` — <how it helps>\n\n'
          .. '## Risks and Open Questions\n'
          .. '- <Anything unresolved>\n\n'
          .. '## Verification Steps\n'
          .. '- <How to confirm correctness>\n\n'
          .. 'Before writing the plan, confirm with the user that they are satisfied with the proposed approach. Only write the plan once they approve.\n\n'
          .. '=== GUIDELINES ===\n'
          .. '- Do NOT write implementation code. Describe what to do, not the literal code.\n'
          .. '- Do NOT skip investigation. Always explore before proposing.\n'
          .. '- When uncertain, ask rather than assume.\n'
          .. '- Reference files by full path.\n'
          .. '- Only quote code when the exact text matters (e.g., a signature to reuse).\n'
          .. '- ONLY use create_file to write the plan to the plans directory. NEVER use it on project files.'
      end,
      tools = {
        'file_search',
        'grep_search',
        'read_file',
        'get_changed_files',
        'get_diagnostics',
        'ask_questions',
        'create_file',
        'memory',
      },
      opts = {
        collapse_tools = true,
        ignore_system_prompt = true,
        ignore_tool_system_prompt = true,
      },
    },
  },

  opts = {
    auto_submit_success = true, -- Send any successful output to the LLM automatically
    -- wait_timeout = 300000,
    -- default_tools = { 'run_command' },
    --- This is needed when using CodeCompanion's internal tools
    --- (e.g., when @{run_command} runs tests and they fail),
    --- but with external tools (e.g., @mcp) this might cause issues
    --- because external tools do not return errors in such cases
    --- but may return errors in case of real internal errors
    --- that should be handled by a human, not an LLM.
    auto_submit_errors = true, -- Send any errors to the LLM automatically
    -- system_prompt = {
    -- enabled = true, -- Enable the tools system prompt?
    -- replace_main_system_prompt = false, -- Replace the main system prompt with the tools system prompt?
    -- },
    allowed_in_yolo_mode = true,
    require_approval_before = false,
    require_cmd_approval = false,
    default_tools = {
      'myagent',
    },
  },
}
