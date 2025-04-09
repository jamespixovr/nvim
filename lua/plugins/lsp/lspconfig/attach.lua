local methods = vim.lsp.protocol.Methods

---@diagnostic disable: need-check-nil
--TODO: work in progress
--https://github.com/nazo6/nvim/blob/master/lua/user/plugins/lsp/lspconfig/attach.lua

local function diagnostic_goto(next, severity)
  local count = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    vim.diagnostic.jump({ count = count, float = true, severity = severity })
  end
end

local function rename()
  if pcall(require, 'inc_rename') then
    vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand('<cword>'), 'n', false)
  else
    vim.lsp.buf.rename()
  end
end

local function codelens(client, bufnr)
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

local go_to_definition = function()
  local ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
  if ft == 'man' then
    vim.api.nvim_command(':Man ' .. vim.fn.expand('<cWORD>'))
  elseif ft == 'help' then
    vim.api.nvim_command(':help ' .. vim.fn.expand('<cword>'))
  else
    Snacks.picker.lsp_definitions()
  end
end

local function keymap(bufnr, client)
  local function map(lhs, rhs, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = '[LSP] ' .. desc, silent = true })
  end

  map('gd', go_to_definition, 'Go to definition')

  vim.keymap.set('n', 'gr', function()
    Snacks.picker.lsp_references()
  end, { buffer = bufnr, desc = 'References', nowait = true })

  map('gi', function()
    Snacks.picker.lsp_implementations()
  end, 'Goto Implementation')

  map('gy', function()
    Snacks.picker.lsp_type_definitions()
  end, 'Goto Type Definition')

  -- map('K', vim.lsp.buf.hover, 'Hover Documentation') -- use the hover vim

  map('gK', vim.lsp.buf.signature_help, 'Signature Help')

  map('gl', "<cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>", 'Show diagnostics')

  map('[d', diagnostic_goto(true), 'Next Diagnostic')
  map(']d', diagnostic_goto(false), 'Next Diagnostic')
  map('<leader>cd', "<cmd>lua vim.diagnostic.open_float({source='if_many'})<cr>", 'Diagnostic')

  map('<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', 'Set loclist')

  map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', '[W]orkspace [A]dd Folder')
  map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', '[W]orkspace [R]emove Folder')

  if client.supports_method(methods.textDocument_codeAction) then
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Actions', { 'n', 'v' })
  end

  map('<leader>cr', rename, '[R]ename')

  map('<leader>ci', '<cmd>LspInfo<cr>', 'Lsp Info')
  map('<leader>ch', vim.lsp.codelens.refresh, 'CodeLens Refresh')
  map('<leader>cl', vim.lsp.codelens.run, '[C]ode[L]ens Run')
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

    keymap(bufnr, client)
    codelens(client, bufnr)
  end,
})
