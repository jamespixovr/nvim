---@diagnostic disable: need-check-nil

local function codelens(bufnr, client)
  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('CodeLens', { clear = false }),
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })
  end
end

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
    codelens(bufnr, client)
  end,
})
