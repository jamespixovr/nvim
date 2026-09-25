---@diagnostic disable: need-check-nil
local function hover_action()
  -- local winid = require('ufo').peekFoldedLinesUnderCursor()
  -- if not winid then
  vim.lsp.buf.hover({ border = 'rounded' })
  -- end
end

local function rename()
  if pcall(require, 'inc_rename') then
    vim.api.nvim_feedkeys(':IncRename ' .. vim.fn.expand('<cword>'), 'n', false)
  else
    vim.lsp.buf.rename()
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

local function keymap(bufnr)
  local function map(lhs, rhs, opts, mode)
    mode = mode or 'n'
    opts = opts or {}
    -- opts.buffer = bufnr
    opts.silent = opts.silent or true
    opts.noremap = true
    opts.buffer = bufnr or true
    opts.desc = string.format('Lsp: %s', opts.desc)
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('K', hover_action, { desc = 'Hover', nowait = true })

  map('gj', function()
    Snacks.picker.diagnostics_buffer()
  end, { desc = 'Find Diagnostics', nowait = true })

  map('gd', go_to_definition, { desc = 'Go to definition' })

  map('grr', function()
    Snacks.picker.lsp_references()
  end, { desc = 'References', nowait = true })

  map('gi', function()
    Snacks.picker.lsp_implementations()
  end, { desc = 'Goto Implementation' })

  map('grt', function()
    Snacks.picker.lsp_type_definitions()
  end, { desc = 'Goto Type Definition' })

  map('gh', function()
    vim.lsp.buf.hover({ border = vim.g.borderStyle })
  end, { desc = 'Hover' })

  map('gK', vim.lsp.buf.signature_help, { desc = 'Signature Help' })

  map('gl', vim.diagnostic.open_float, { desc = 'View current diagnostic' })

  map('<leader>ql', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix [l]ist' })

  map('<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', { desc = '[W]orkspace [A]dd Folder' })
  map('<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', { desc = '[W]orkspace [R]emove Folder' })

  -- if client.supports_method(methods.textDocument_codeAction) then
  map('<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Actions' }, { 'n', 'v' })
  -- end

  map('<leader>cr', rename, { desc = '[R]ename' })
  map('grn', vim.lsp.buf.rename, { desc = '[R]ename' })

  map('<leader>ch', function()
    vim.lsp.codelens.enable(true)
  end, { desc = 'CodeLens Refresh' })
  map('<leader>cl', vim.lsp.codelens.run, { desc = '[C]ode[L]ens Run' })
  map('<leader>th', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = 'Toggle inlay hints' })

  map('<leader>gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
  map('grd', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
end

local function disable_global_keymaps()
  for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr' }) do
    pcall(vim.keymap.del, 'n', bind)
  end
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(args)
    disable_global_keymaps()

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local bufnr = args.buf

    if client == nil then
      return
    end

    if client.name == 'copilot' then
      return
    end

    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    -- Disable codelens for lua (lua_ls "0 References" is noisy)
    if client.name == 'lua_ls' then
      vim.lsp.codelens.enable(false, { bufnr = bufnr })
    end

    -- Inline completion
    if client:supports_method('textDocument/inlineCompletion', bufnr) then
      vim.lsp.inline_completion.enable(true)
    end

    -- Linked editing (e.g., paired HTML tags)
    if client:supports_method('textDocument/linkedEditingRange', bufnr) then
      vim.lsp.linked_editing_range.enable(true, { bufnr = bufnr })
    end

    -- Inline color swatches
    if client:supports_method('textDocument/documentColor', bufnr) then
      vim.lsp.document_color.enable(true, { bufnr = bufnr })
    end

    -- if client.name == 'yamlls' then
    --   -- Need this so that conform uses LSP to format yaml.* files.
    --   client.server_capabilities.documentFormattingProvider = true
    -- end

    if client.name == 'vue_ls' then
      -- Disable rename in hybrid mode (vtsls handles it)
      client.server_capabilities.renameProvider = false
    end

    -- Prevent LSP from attaching to virtual buffers such as diffview.
    -- local bufname = vim.api.nvim_buf_get_name(args.buf)
    -- if bufname:match('^diffview://') then
    --   vim.schedule(function()
    --     vim.lsp.buf_detach_client(args.buf, args.data.client_id)
    --   end)
    -- end

    keymap(bufnr)
  end,
})

-- Reset diagnostics on detach so :lsp restart/:lsp stop don't leave stale state.
vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('lsp-detach-cleanup', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local prefix = ('nvim.lsp.%s.%d'):format(client.name, client.id)
    for namespace, metadata in pairs(vim.diagnostic.get_namespaces()) do
      local name = metadata.name or ''
      if name == prefix or vim.startswith(name, prefix .. '.') then
        vim.diagnostic.reset(namespace)
      end
    end
  end,
})

vim.api.nvim_create_user_command('LspLog', function()
  vim.cmd('edit ' .. vim.lsp.log.get_filename())
end, {})

-- disable lsp for .env files
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = { '*.env', '.env*' },
  group = (vim.api.nvim_create_augroup('__env', { clear = true })),
  callback = function(args)
    vim.cmd([[set filetype=sh]]) -- set ft to sh to enable syntax highlighting
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})
