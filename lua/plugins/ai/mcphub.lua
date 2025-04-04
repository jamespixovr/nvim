return {
  {
    'ravitemer/mcphub.nvim',
    version = '*',
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = { 'MCPHub' },
    build = 'npm install -g mcp-hub@latest',
    opts = {
      port = 3000,
      config = vim.fn.expand('~/mcpservers.json'),
      extensions = {
        codecompanion = {
          -- Show the mcp tool result in the chat buffer
          -- NOTE:if the result is markdown with headers, content after the headers wont be sent by codecompanion
          show_result_in_chat = true,
          make_vars = true, -- make chat #variables from MCP server resources
          make_slash_commands = true, -- make /slash_commands from MCP server prompts
        },
      },
    },
  },
}
