--------------------------------------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------------------------------------
local function format_diagnostic(prefix, diagnostic)
  local formatted_message = diagnostic
    .message
    -- Replace any sequence of whitespace characters (including newlines) with a single space
    :gsub('%s+', ' ')
  return string.format(prefix .. ' %s', formatted_message)
end

local diagnostic_config = {
  severity_sort = true,
  signs = {
    -- text = { '', '▲', '●', '' }, -- Error, Warn, Info, Hint
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
    },
  },
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return format_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return format_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return format_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return format_diagnostic('󰌶', diagnostic)
      end
      return format_diagnostic('■', diagnostic)
    end,
  },
  float = {
    focusable = true,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    max_width = 70,
    header = '',
    prefix = function(_, _, total)
      return (total > 1 and '• ' or ''), 'Comment'
    end,
    suffix = function(diag)
      local source = (diag.source or ''):gsub(' ?%.$', '')
      local code = diag.code and ': ' .. diag.code or ''
      return ' ' .. source .. code, 'Comment'
    end,
    format = function(diag)
      local msg = diag.message:gsub('%.$', '')
      return msg
    end,
  },
}

vim.diagnostic.config(diagnostic_config)

---@param direction 'forward' | 'backward'
local function cycle_diagnostic_modes(direction)
  local current_config = diagnostic_config
  -- local current_config = vim.diagnostic.config() or diagnostic_config
  local modes = {
    {
      virtual_text = {
        prefix = '',
        format = function(diagnostic)
          local severity = diagnostic.severity
          if severity == vim.diagnostic.severity.ERROR then
            return format_diagnostic('󰅚', diagnostic)
          end
          if severity == vim.diagnostic.severity.WARN then
            return format_diagnostic('⚠', diagnostic)
          end
          if severity == vim.diagnostic.severity.INFO then
            return format_diagnostic('ⓘ', diagnostic)
          end
          if severity == vim.diagnostic.severity.HINT then
            return format_diagnostic('󰌶', diagnostic)
          end
          return format_diagnostic('■', diagnostic)
        end,
      },
      virtual_lines = false,
    },
    { virtual_text = false, virtual_lines = true },
    { virtual_text = false, virtual_lines = false },
  }

  local current_mode_index
  for i, mode in ipairs(modes) do
    if
      (
        (
          type(current_config.virtual_text) == 'table'
          and mode.virtual_text
            == {
              prefix = '',
              format = function(diagnostic)
                local severity = diagnostic.severity
                if severity == vim.diagnostic.severity.ERROR then
                  return format_diagnostic('󰅚', diagnostic)
                end
                if severity == vim.diagnostic.severity.WARN then
                  return format_diagnostic('⚠', diagnostic)
                end
                if severity == vim.diagnostic.severity.INFO then
                  return format_diagnostic('ⓘ', diagnostic)
                end
                if severity == vim.diagnostic.severity.HINT then
                  return format_diagnostic('󰌶', diagnostic)
                end
                return format_diagnostic('■', diagnostic)
              end,
            }
        ) or (current_config.virtual_text == mode.virtual_text)
      ) and (current_config.virtual_lines == mode.virtual_lines)
    then
      current_mode_index = i
      break
    end
  end
  local next_mode_index
  if direction == 'forward' then
    next_mode_index = (current_mode_index % #modes) + 1
  else
    next_mode_index = (current_mode_index - 2 + #modes) % #modes + 1
  end
  vim.diagnostic.config(vim.tbl_extend('force', current_config, modes[next_mode_index]))
end

vim.keymap.set('n', '<space>d]', function()
  cycle_diagnostic_modes('forward')
end, { noremap = true, silent = true })

vim.keymap.set('n', '<space>d[', function()
  cycle_diagnostic_modes('backward')
end, { noremap = true, silent = true })

-- vim.api.nvim_create_autocmd('BufEnter', {
--   group = vim.api.nvim_create_augroup('DisableNewLineAutoCommentString', {}),
--   callback = function()
--     vim.opt.formatoptions = vim.opt.formatoptions - { 'c', 'r', 'o' }
--   end,
-- })
