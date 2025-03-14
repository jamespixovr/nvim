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
    opts = function()
      return {
        port = 3000,
        config = vim.fn.expand('~/mcpservers.json'),
      }
    end,
  },
}
