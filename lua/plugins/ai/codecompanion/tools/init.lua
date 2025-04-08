return {
  ['code_crawler'] = require('plugins.ai.codecompanion.tools.code_crawler'),
  ['code_edit'] = require('plugins.ai.codecompanion.tools.code_edit'),
  ['mcp'] = require('plugins.ai.codecompanion.tools.mcp'),
  ['tavily'] = require('plugins.ai.codecompanion.tools.tavily'),

  opts = {
    auto_submit_errors = true, -- Send any errors to the LLM automatically
    auto_submit_success = true, -- Send any successful output to the LLM automatically
  },
}
