local DEFAULT_MODEL = 'openai/gpt-oss-120b' -- grok-code-fast-1, gpt-4.1
local DEFAULT_ADAPTOR = 'openrouter_background'

return {
  -- history = {
  --   enabled = true,
  --   auto_save = true,
  --   expiration_days = 45,
  --   opts = {
  --     -- Keymap to open history from chat buffer (default: gh)
  --     keymap = 'gh',
  --     -- Automatically generate titles for new chats
  --     auto_generate_title = false,
  --     ---On exiting and entering neovim, loads the last chat on opening chat
  --     continue_last_chat = false,
  --     ---When chat is cleared with `gx` delete the chat from history
  --     delete_on_clearing_chat = false,
  --     -- Picker interface ("telescope", "snacks" or "default")
  --     picker = 'snacks',
  --     ---Enable detailed logging for history extension
  --     enable_logging = false,
  --     ---Directory path to save the chats
  --     dir_to_save = vim.fn.stdpath('data') .. '/codecompanion-history',
  --     auto_save = true,
  --     -- Number of days after which chats are automatically deleted (0 to disable)
  --     expiration_days = 45,
  --     save_chat_keymap = 'sc',
  --     title_generation_opts = {
  --       adapter = DEFAULT_ADAPTOR,
  --       model = DEFAULT_MODEL,
  --       refresh_every_n_prompts = 3,
  --       max_refreshes = 10,
  --     },
  --     picker_keymaps = {
  --       rename = { n = 'gr', i = '<C-r>' },
  --       delete = { n = 'dd', i = '<C-d>' },
  --       duplicate = { n = 'yyp', i = '<C-y>' },
  --     },
  --     chat_filter = function(chat_data) -- only chats for the cwd
  --       return chat_data.cwd == vim.fn.getcwd()
  --     end,
  --     summary = {
  --       create_summary_keymap = 'gcs',
  --       browse_summaries_keymap = 'gbs',
  --
  --       generation_opts = {
  --         adapter = nil, -- defaults to current chat adapter
  --         model = nil, -- defaults to current chat model
  --         context_size = 128000, -- max tokens that the model supports
  --         include_references = true, -- include slash command content
  --         include_tool_outputs = true, -- include tool execution results
  --         system_prompt = nil, -- custom system prompt (string or function)
  --         format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
  --       },
  --     },
  --   },
  -- },
  gitcommit = {
    callback = 'codecompanion._extensions.gitcommit',
    opts = {
      adapter = DEFAULT_ADAPTOR, -- Optional: specify LLM adapter (defaults to codecompanion chat adapter)
      model = DEFAULT_MODEL, -- default model for gitcommit
      languages = { 'English' }, -- Optional: specify languages for diff analysis
      exclude_files = {
        '*.generated.*',
        '*.lock',
        '*.log',
        '*.min.css',
        '*.min.js',
        '*.pb.go',
        '*gen.go',
        '.next/*',
        'build/*',
        'dist/*',
        'node_modules/*',
        'package-lock.json',
        'pnpm-lock.yaml',
        'vendor/*',
        'vendor/*',
        'yarn.lock',
      }, -- Optional: exclude files from diff analysis
      buffer = {
        enabled = true, -- Enable gitcommit buffer keymaps
        keymap = '<leader>gc', -- Keymap for generating commit message in gitcommit buffer
        auto_generate = false, -- Automatically generate message on entering gitcommit buffer
      },
      -- Feature toggles
      add_slash_command = true, -- Add /gitcommit slash command
      add_git_tool = true, -- Add @git_read and @git_edit tools
      enable_git_read = true, -- Enable read-only Git operations
      enable_git_edit = true, -- Enable write-access Git operations
      enable_git_bot = true, -- Enable @git_bot tool group (requires both read/write enabled)
      add_git_commands = true, -- Add :CodeCompanionGitCommit commands
      git_tool_auto_submit_errors = false, -- Auto-submit errors to LLM
      git_tool_auto_submit_success = true, -- Auto-submit success to LLM
      gitcommit_select_count = 100, -- Number of commits shown in /gitcommit
      use_commit_history = true, -- Enable commit history context
      commit_history_count = 10, -- Number of recent commits for context
      include_issue_id_from_branch = true, -- Enable automatic issue ID extraction
      issue_id_patterns = { -- Patterns for extracting issue IDs
        { pattern = '^bcd%-(%d%d%d%d)', prefix = 'BCD', format = 'BCD-%s' },
        { pattern = 'MOB%-(%d+)', prefix = 'MOB', format = 'MOB-%s' },
        { pattern = 'TEC%-(%d+)', prefix = 'TEC', format = 'TEC-%s' },
        { pattern = 'ENG%-(%d+)', prefix = 'ENG', format = 'ENG-%s' },
        { pattern = 'INF%-(%d+)', prefix = 'INF', format = 'INF-%s' },
      },
    },
  },
  -- agentskills = {
  --   opts = {
  --     paths = {
  --       -- { '~/.config/skills/.claude/skills', recursive = true },
  --       { '~/.agents/skills', recursive = true }, -- Recursive search
  --       { '.claude/skills', recursive = true }, -- Recursive search
  --     },
  --   },
  -- },
  -- spinner = {
  --   opts = {
  --     log_level = 'info',
  --     -- Available options: "cursor-relative", "snacks", "fidget", "lualine", "heirline", "native", "none"
  --     style = 'snacks',
  --   },
  -- },
}
