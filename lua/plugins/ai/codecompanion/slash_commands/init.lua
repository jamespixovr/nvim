return {
  ['buffer'] = { opts = { provider = 'snacks', keymaps = { modes = { i = '<C-b>' } } } },
  ['help'] = { opts = { provider = 'snacks', max_lines = 1000 } },
  ['file'] = { opts = { provider = 'snacks' } },
  ['symbols'] = { opts = { provider = 'snacks' } },

  ['agent_mode'] = require('plugins.ai.codecompanion.slash_commands.agent_mode'),
  ['codeforces_companion'] = require('plugins.ai.codecompanion.slash_commands.codeforces_companion'),
  ['git_commit'] = require('plugins.ai.codecompanion.slash_commands.git_commit'),
  ['git_files'] = require('plugins.ai.codecompanion.slash_commands.git_files'),
  ['review_git_diffs'] = require('plugins.ai.codecompanion.slash_commands.review_git_diffs'),
  ['review_merge_request'] = require('plugins.ai.codecompanion.slash_commands.review_merge_request'),
  ['thinking'] = require('plugins.ai.codecompanion.slash_commands.thinking'),

  ['summarize_text'] = require('plugins.ai.codecompanion.slash_commands.summarize_text'),
  ['delete_session'] = require('plugins.ai.codecompanion.slash_commands.delete_session'),
  ['dump_session'] = require('plugins.ai.codecompanion.slash_commands.dump_session'),
  ['restore_session'] = require('plugins.ai.codecompanion.slash_commands.restore_session'),
  ['plan_mode'] = require('plugins.ai.codecompanion.slash_commands.plan_mode'),
  ['terminal'] = require('plugins.ai.codecompanion.slash_commands.terminal'),
}
