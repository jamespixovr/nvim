require('lspconfig.ui.windows').default_options.border = vim.g.borderStyle

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  silent = true,
  border = vim.g.borderStyle,
})

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  focus = false,
  border = vim.g.borderStyle,
})

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  opts.max_height = opts.max_height or 40
  opts.max_width = opts.max_width or 100
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

---@param diag vim.Diagnostic
---@return string displayedText
local function addCodeAndSourceAsSuffix(diag)
  if not diag.source then
    return ''
  end
  local source = diag.source:gsub(' ?%.$', '') -- rm trailing dot for lua_ls
  local code = diag.code and ': ' .. diag.code or ''
  return (' (%s%s)'):format(source, code)
end

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '', -- "✘"
      [vim.diagnostic.severity.WARN] = '▲',
      [vim.diagnostic.severity.INFO] = '●',
      [vim.diagnostic.severity.HINT] = '',
    },
  },
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN }, -- leave out hints & info
    suffix = addCodeAndSourceAsSuffix,
  },
  float = {
    severity_sort = true,
    border = vim.g.borderStyle,
    max_width = 70,
    header = '',
    prefix = function(_, _, total)
      local bullet = total > 1 and '• ' or ''
      return bullet, 'Comment'
    end,
    suffix = function(diag)
      return addCodeAndSourceAsSuffix(diag), 'Comment'
    end,
  },
})
-- enable virtual text diagnostics for Neotest only
-- vim.diagnostic.config({ virtual_text = true }, vim.api.nvim_create_namespace('neotest'))
