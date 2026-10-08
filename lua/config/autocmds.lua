local function augroup(name)
  return vim.api.nvim_create_augroup('jarmex_neovim_' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = augroup('general_settings'),
  pattern = '*',
  desc = 'Highlight text on yank',
  callback = function()
    vim.highlight.hl_op({ higroup = 'Visual', timeout = 200 })
    vim.highlight.hl_op({ higroup = 'Search', timeout = 100 })
    vim.highlight.hl_op({ higroup = 'IncSearch', timeout = 200 })
  end,
})

-- -- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('filetype_settings'),
  pattern = { 'lua' },
  desc = 'fix gf functionality inside .lua files',
  callback = function()
    ---@diagnostic disable: assign-type-mismatch
    -- credit: https://github.com/sam4llis/nvim-lua-gf
    vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
    vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
    vim.opt_local.suffixesadd:prepend('.lua')
    vim.opt_local.suffixesadd:prepend('init.lua')

    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
      vim.opt_local.path:append(path .. '/lua')
    end
  end,
})

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('buffer_mappings'),
  pattern = {
    'DressingSelect',
    'Jaq',
    'OverseerList',
    'PlenaryTestPopup',
    'dropbar_menu',
    'floaterm',
    'help',
    'lir',
    'lsp-installer',
    'lspinfo',
    'man',
    'neotest-output',
    'neotest-summary',
    'null-ls-info',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
    vim.bo[event.buf].buflisted = false
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '.env',
  group = augroup('__env'),
  callback = function(args)
    vim.diagnostic.enable(false, { bufnr = args.buf })
  end,
})

-- Define local variables
local autocmd = vim.api.nvim_create_autocmd

-- Check for spelling in text filetypes and enable wrapping, and set gj and gk keymaps
autocmd('FileType', {
  group = augroup('set_wrap'),
  pattern = {
    'gitcommit',
    'markdown',
    'text',
    'html',
    'plaintex',
  },
  desc = 'setlocal wrap and spell',
  callback = function()
    local opts = { noremap = true, silent = true }
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
    vim.api.nvim_buf_set_keymap(0, 'n', 'j', 'gj', opts)
    vim.api.nvim_buf_set_keymap(0, 'n', 'k', 'gk', opts)
  end,
})
-- local mapfile = " "

-- Set up the autocommand for TS filetype
-- Add missing imports and remove unused imports
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   group = vim.api.nvim_create_augroup('ts_fix_imports', { clear = true }),
--   desc = 'Add missing imports and remove unused imports for TS',
--   pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
--   callback = function(args)
--     -- vim.cmd('TSToolsAddMissingImports sync')
--     -- vim.cmd('TSToolsRemoveUnusedImports sync')
--     if package.loaded['conform'] then
--       require('conform').format({ bufnr = args.buf })
--     end
--   end,
-- })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go', 'gomod', 'gowork' },
  callback = function()
    -- set go specific options
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.colorcolumn = '120'
  end,
})

-- Prevent LSP from attaching to quickfix buffers — quicker.nvim's setqflist
-- calls trigger LSP change-tracking which hits an assertion in sync.lua:225
vim.api.nvim_create_autocmd('LspAttach', {
  group = augroup('qf_no_lsp'),
  desc = 'Detach LSP from quickfix buffers to prevent sync.lua assertion failures',
  callback = function(event)
    if vim.bo[event.buf].filetype == 'qf' then
      vim.schedule(function()
        vim.lsp.buf_detach_client(event.buf, event.data.client_id)
      end)
    end
  end,
})

--------------------------------------------------------------------------------

-- AUTO-CLEANUP
vim.api.nvim_create_autocmd('FocusLost', {
  desc = 'User: Auto-cleanup. Once a week, on first `FocusLost`, delete older files.',
  once = true,
  callback = function()
    if os.date('%a') ~= 'Mon' or jit.os == 'windows' then
      return
    end
    vim.system({ 'find', vim.o.undodir, '-mtime', '+15d', '-delete' })
    vim.system({ 'find', vim.lsp.log.get_filename(), '-size', '+50M', '-delete' })
  end,
})

-- create colorcolumn according to filetype
local cc_filetypes = {
  c = '120',
  cpp = '120',
  java = '120',
  javascript = '120',
  javascriptreact = '120',
  kotlin = '120',
  lua = '120',
  typescript = '120',
  typescriptreact = '120',
  rust = '120',
  haskell = '120',
  swift = '120',
  markdown = '100',
}
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup('colorcolumn'),
  callback = function(event)
    local filetype = event.match
    if cc_filetypes[filetype] then
      vim.opt_local.colorcolumn = cc_filetypes[filetype]
    else
      vim.opt_local.colorcolumn = ''
    end
  end,
})
