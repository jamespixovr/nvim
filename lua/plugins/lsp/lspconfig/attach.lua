local methods = vim.lsp.protocol.Methods

---@diagnostic disable: need-check-nil
--TODO: work in progress
--https://github.com/nazo6/nvim/blob/master/lua/user/plugins/lsp/lspconfig/attach.lua

local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

local function rename()
  if pcall(require, 'inc_rename') then
    vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand('<cword>'), 'n', false)
  else
    vim.lsp.buf.rename()
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(ctx)
    local bufnr = ctx.buf

    local function map(lhs, rhs, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = '[LSP] ' .. desc })
    end

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

    if client.name == 'ruff_lsp' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    local go_to_definition = function()
      local ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
      if ft == 'man' then
        vim.api.nvim_command(':Man ' .. vim.fn.expand('<cWORD>'))
      elseif ft == 'help' then
        vim.api.nvim_command(':help ' .. vim.fn.expand('<cword>'))
      else
        require('fzf-lua').lsp_definitions({ jump_to_single_result = true })
      end
    end

    map('gd', go_to_definition, 'Go to definition')

    if client.supports_method(methods.textDocument_definition) then
      map('gD', vim.lsp.buf.declaration, '[G]o [D]eclaration')
    end

    map('gr', 'FzfLua lsp_references', 'References', { nowait = true })
    -- map('gr', vim.lsp.buf.references, 'References', { nowait = true })
    -- map('gi', vim.lsp.buf.implementation, 'Goto Implementation')

    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = bufnr, desc = 'References', nowait = true })
    map('gi', 'FzfLua lsp_implementations', 'Goto Implementation')
    map('gy', vim.lsp.buf.type_definition, 'Goto Type Definition')

    map('K', vim.lsp.buf.hover, 'Hover Documentation')

    if client.supports_method(methods.textDocument_signatureHelp) then
      map('gK', vim.lsp.buf.signature_help, 'Signature Help')
      map('<C-k>', function()
        -- Close the completion menu first (if open).
        local cmp = require('cmp')
        if cmp.visible() then
          cmp.close()
        end

        vim.lsp.buf.signature_help()
      end, 'Signature help', 'i')
    end

    map('gl', "<cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>", 'Show diagnostics')

    map('[d', diagnostic_goto(true), 'Next Diagnostic')
    map(']d', diagnostic_goto(false), 'Next Diagnostic')

    map('<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set loclist')

    map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', '[W]orkspace [A]dd Folder')
    map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', '[W]orkspace [R]emove Folder')
    map(
      '<leader>wl',
      '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
      '[W]orkspace [L]ist Folders'
    )
    -- map("gy", vim.lsp.buf.declaration, "[LSP] Go declaration")
    map('gy', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')

    map('<leader>ws', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
    map('<leader>wS', function()
      -- Disable the grep switch header.
      require('fzf-lua').lsp_live_workspace_symbols({ no_header_i = true })
    end, 'Workspace symbols')

    if client.supports_method(methods.textDocument_codeAction) then
      map('<leader>ca', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'v' })
    end

    if client.supports_method(methods.textDocument_rename) then
      map('<leader>cr', rename, '[R]ename')
    end

    map('<leader>ci', '<cmd>LspInfo<cr>', 'Lsp Info')
    map('<leader>ch', vim.lsp.codelens.refresh, 'CodeLens Refresh')
    map('<leader>cl', vim.lsp.codelens.run, '[C]ode[L]ens Run')
  end,
})
