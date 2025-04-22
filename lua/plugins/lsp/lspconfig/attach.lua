---@diagnostic disable: need-check-nil
local debounce = require('lib.utils').debounce
local autocmd = vim.api.nvim_create_autocmd

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ctx)
    local bufnr = ctx.buf

    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
    assert(client, 'No client found')

    if client.name == 'copilot' then
      return
    end

    if client.name == 'gopls' then
      if not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = {
            tokenTypes = semantic.tokenTypes,
            tokenModifiers = semantic.tokenModifiers,
          },
          range = true,
        }
      end
    end

    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    require('plugins.lsp.lspconfig.keymaps').keymap(bufnr)

    if client:supports_method('textDocument/codeLens') then
      vim.lsp.codelens.refresh({ bufnr = bufnr })
      vim.api.nvim_create_autocmd({ 'FocusGained', 'WinEnter', 'BufEnter', 'CursorMoved' }, {
        -- callback = debounce(200, function(args0)
        callback = debounce(20, function(args0)
          vim.lsp.codelens.refresh({ bufnr = args0.buf })
        end),
      })
      -- Code lens setup, don't call again
      return true
    end
  end,
})

do -- textDocument/documentHighlight
  local method = 'textDocument/documentHighlight'

  autocmd({ 'FocusGained', 'WinEnter', 'BufEnter', 'CursorMoved' }, {
    callback = debounce(200, function(args)
      vim.lsp.buf.clear_references()
      local win = vim.api.nvim_get_current_win()
      local bufnr = args.buf --- @type integer
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr, method = method })) do
        local enc = client.offset_encoding
        client:request(method, vim.lsp.util.make_position_params(0, enc), function(_, result, ctx)
          if not result or win ~= vim.api.nvim_get_current_win() then
            return
          end
          vim.lsp.util.buf_highlight_references(ctx.bufnr, result, enc)
        end, bufnr)
      end
    end),
  })

  autocmd({ 'FocusLost', 'WinLeave', 'BufLeave' }, {
    callback = vim.lsp.buf.clear_references,
  })
end
