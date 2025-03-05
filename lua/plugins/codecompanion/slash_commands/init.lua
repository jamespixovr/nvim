return {
  ['buffer'] = { opts = { provider = 'snacks', keymaps = { modes = { i = '<C-b>' } } } },
  ['help'] = { opts = { provider = 'snacks', max_lines = 1000 } },
  ['file'] = { opts = { provider = 'snacks' } },
  ['symbols'] = { opts = { provider = 'snacks' } },

  ['agent_mode'] = require('plugins.codecompanion.slash_commands.agent_mode'),
  ['codeforces_companion'] = require('plugins.codecompanion.slash_commands.codeforces_companion'),
  ['git_commit'] = require('plugins.codecompanion.slash_commands.git_commit'),
  ['git_files'] = require('plugins.codecompanion.slash_commands.git_files'),
  ['review_git_diffs'] = require('plugins.codecompanion.slash_commands.review_git_diffs'),
  ['review_merge_request'] = require('plugins.codecompanion.slash_commands.review_merge_request'),
  ['thinking'] = require('plugins.codecompanion.slash_commands.thinking'),
}
