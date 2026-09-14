return {
  ['buffer'] = { opts = { provider = 'snacks', contains_code = true, keymaps = { modes = { i = '<C-b>' } } } },
  ['help'] = { opts = { provider = 'snacks', contains_code = true, max_lines = 1000 } },
  ['file'] = { opts = { provider = 'snacks', contains_code = true, max_lines = 1000 } },
  ['symbols'] = { opts = { provider = 'snacks', contains_code = true } },
  ['fetch'] = { opts = { adapter = 'markitdown' } },
  ['image'] = { opts = { dirs = { '~/Desktop' } } },
  ['workspace'] = { opts = { contains_code = true, provider = 'snacks' } },
  ['terminal'] = { opts = { contains_code = true, provider = 'snacks' } },
  ['agent_mode'] = require('plugins.ai.codecompanion.slash_commands.agent_mode'),
  -- ['codeforces_companion'] = require('plugins.ai.codecompanion.slash_commands.codeforces_companion'),
  ['review_merge_request'] = require('plugins.ai.codecompanion.slash_commands.review_merge_request'),
  ['thinking'] = require('plugins.ai.codecompanion.slash_commands.thinking'),

  ['summarize_text'] = require('plugins.ai.codecompanion.slash_commands.summarize_text'),
  ['plan_mode'] = require('plugins.ai.codecompanion.slash_commands.plan_mode'),
  ['meta_prompt'] = require('plugins.ai.codecompanion.slash_commands.meta_prompt'),
  require('plugins.ai.codecompanion.slash_commands.changelog'),
}
