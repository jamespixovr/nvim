local promptList = require('plugins.ai.codecompanion.promptlibrary.awesome-prompts')

return vim.tbl_extend('force', promptList.prompt_library(), {
  ['Explain architecture'] = require('plugins.ai.codecompanion.promptlibrary.explain_architecture'),
  ['Suggest Refactoring'] = require('plugins.ai.codecompanion.promptlibrary.suggest_refactoring'),
  ['Add DocBlock'] = require('plugins.ai.codecompanion.promptlibrary.docblock'),
  ['Git Diff Code Review'] = require('plugins.ai.codecompanion.promptlibrary.git_diff_code_review'),
  ['inline'] = require('plugins.ai.codecompanion.promptlibrary.inline'),
  ['Code review'] = require('plugins.ai.codecompanion.promptlibrary.code_review'),
  ['Explain code'] = require('plugins.ai.codecompanion.promptlibrary.explain_code'),
  ['Code Expert'] = require('plugins.ai.codecompanion.promptlibrary.code_expert'),
  ['Review'] = require('plugins.ai.codecompanion.promptlibrary.review'),
  ['Generate Docstring'] = require('plugins.ai.codecompanion.promptlibrary.doc_string'),
  ['Refactor'] = require('plugins.ai.codecompanion.promptlibrary.refactor'),
  ['Pull Request'] = require('plugins.ai.codecompanion.promptlibrary.pullrequest'),
  ['Spell'] = require('plugins.ai.codecompanion.promptlibrary.spell'),
  ['Bug Finder'] = require('plugins.ai.codecompanion.promptlibrary.bug_finder'),
  ['Agent Mode'] = require('plugins.ai.codecompanion.promptlibrary.agent_mode'),
  ['Generate a Commit Message for Staged Files'] = require('plugins.ai.codecompanion.promptlibrary.scommit'),
  ['Proof Read'] = require('plugins.ai.codecompanion.promptlibrary.proofread'),
  ['Naming'] = require('plugins.ai.codecompanion.promptlibrary.naming'),
  ['Vibe Code'] = require('plugins.ai.codecompanion.promptlibrary.vibe_code'),
  ['Platform Commit'] = require('plugins.ai.codecompanion.promptlibrary.platform-commit'),
})
