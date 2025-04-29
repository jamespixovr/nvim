return {
  {
    'ravitemer/mcphub.nvim',
    version = '*',
    enabled = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    cmd = { 'MCPHub' },
    build = 'pnpm add -g mcp-hub@latest',
    opts = {
      port = 4004,
      config = (function()
        if vim.fn.has('mac') then
          return vim.fn.expand(vim.fn.stdpath('config') .. '/mac_mcphub_servers.json')
        end
        return vim.fn.expand(vim.fn.stdpath('config') .. '/mcphub_servers.json')
      end)(),
    },
    config = function(_, opts)
      local root = vim.fs.root(0, '.git')
      if root then
        vim.fn.setenv('MCP_PROJECT_ROOT_PATH', root)
      end
      require('mcphub').setup(opts)
    end,
  },
}
