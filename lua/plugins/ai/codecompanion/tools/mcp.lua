return {
  -- Prevent mcphub from loading before needed
  callback = function()
    return require('mcphub.extensions.codecompanion')
  end,
  description = 'Call tools and resources from the MCP Servers',
}
