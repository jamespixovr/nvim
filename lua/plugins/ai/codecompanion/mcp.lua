local M = {}

M.mcpServers = {
  opts = {
    -- default_servers = { 'memory' },
  },
  servers = {
    ['memory'] = {
      cmd = { 'npx', '-y', '@modelcontextprotocol/server-memory' },
    },
    ['fireflies'] = {
      cmd = { 'npx', '-y', 'mcp-remote', 'https://api.fireflies.ai/mcp' },
      tool_defaults = {
        require_approval_before = false,
      },
    },
    ['atlassian'] = {
      cmd = { 'npx', '-y', 'mcp-remote', 'https://mcp.atlassian.com/v1/mcp' },
    },
    ['github'] = {
      type = 'http',
      url = 'https://api.githubcopilot.com/mcp/',
    },
    ['kubernetes'] = {
      cmd = { 'npx', 'mcp-server-kubernetes' },
    },
    ['playwright'] = {
      cmd = { 'npx', '@playwright/mcp@latest' },
    },
    ['basic-memory'] = {
      cmd = { 'uvx', 'basic-memory', 'mcp' },
    },
    ['sequential-thinking'] = {
      cmd = { 'npx', '-y', '@modelcontextprotocol/server-sequential-thinking' },
    },
    ['tavily-mcp'] = {
      cmd = { 'npx', '-y', 'tavily-mcp@latest' },
      env = {
        -- TAVILY_API_KEY = 'cmd:op read op://personal/Tavily_API/credential --no-newline',
      },
      tool_defaults = {
        require_approval_before = true,
      },
    },
    ['claude_memory'] = {
      cmd = { 'npx', '-y', '@modelcontextprotocol/server-filesystem', os.getenv('HOME') .. '/.claude/projects' },
    },
    ['linear'] = {
      cmd = { 'npx', '-y', 'mcp-remote', 'https://mcp.linear.app/mcp' },
      tool_defaults = {
        require_approval_before = false,
      },
      tool_overrides = {
        delete_attachment = { opts = { require_approval_before = true } },
        delete_comment = { opts = { require_approval_before = true } },
        save_issue = { opts = { require_approval_before = true } },
        create_issue_label = { opts = { require_approval_before = true } },
        save_project = { opts = { require_approval_before = true } },
        save_initiative = { opts = { require_approval_before = true } },
        save_status_update = { opts = { require_approval_before = true } },
        delete_status_update = { opts = { require_approval_before = true } },
      },
    },
  },
}
return M
