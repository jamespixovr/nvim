---ensures unique keymaps https://www.reddit.com/r/neovim/comments/16h2lla/can_you_make_neovim_warn_you_if_your_config_maps/
---@param modes "n"|"v"|"x"|"i"|"o"|"c"|"t"|"ia"|"ca"|"!a"|string[]
---@param lhs string
---@param rhs string|function
---@param opts? { unique: boolean, desc: string, buffer: boolean, nowait: boolean, remap: boolean }
local function keymap(modes, lhs, rhs, opts)
  if not opts then
    opts = {}
  end
  if opts.unique == nil then
    opts.unique = true
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

-- Better window movement
-- Move to window using the <ctrl> hjkl keys
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', noremap = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', noremap = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', noremap = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', noremap = true })

-- local keymap = vim.keymap.set

-- Remap for dealing with word wrap
keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better viewing
keymap('n', 'n', 'nzzzv')
keymap('n', 'N', 'Nzzzv')
keymap('n', 'g,', 'g,zvzz')
keymap('n', 'g;', 'g;zvzz')

-- Better indent
keymap('v', '<', '<gv')
keymap('v', '>', '>gv')

-- Paste over currently selected text without yanking it
keymap('v', 'p', '"_dP')

--[[-- jk is mapped to escape by better-escape.nvim plugin]]
-- 'jk' for quitting insert mode
-- keymap("i", "jk", "<ESC>")
-- keymap("i", "kj", "<ESC>")

-- COMMAND & INSERT MODE
keymap({ 'i', 'c' }, '<C-a>', '<Home>')
keymap({ 'i', 'c' }, '<C-e>', '<End>')

-- navigation
keymap('i', '<C-Up>', '<C-\\><C-N><C-w>k')
keymap('i', '<C-Down>', '<C-\\><C-N><C-w>j')
keymap('i', '<C-Left>', '<C-\\><C-N><C-w>h')
keymap('i', '<C-Right>', '<C-\\><C-N><C-w>l')

-- Terminal Mappings
keymap('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Enter Normal Mode' })
keymap('t', '<C-h>', '<cmd>wincmd h<cr>', { desc = 'Go to left window' })
keymap('t', '<C-j>', '<cmd>wincmd j<cr>', { desc = 'Go to lower window' })
keymap('t', '<C-k>', '<cmd>wincmd k<cr>', { desc = 'Go to upper window' })
keymap('t', '<C-l>', '<cmd>wincmd l<cr>', { desc = 'Go to right window' })
keymap('t', '<C-/>', '<cmd>close<cr>', { desc = 'Hide Terminal' })
keymap('t', '<c-_>', '<cmd>close<cr>', { desc = 'which_key_ignore' })
-- QuickFix
keymap('n', ']q', ':cnext<CR>')
keymap('n', '[q', ':cprev<CR>')
keymap('n', '<C-q>', ':call QuickFixToggle()<CR>')

-- Clear search with <esc>
keymap({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })
keymap('n', '<leader><space>', ':nohlsearch<CR>')

keymap('n', '<leader>bo', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- save file
-- keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- lazy
keymap('n', '<leader>ll', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- windows
keymap('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
keymap('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
keymap('n', '<leader>w-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap('n', '<leader>w|', '<C-W>v', { desc = 'Split window right', remap = true })
keymap('n', '<leader>-', '<C-W>s', { desc = 'Split window below', remap = true })
keymap('n', '<leader>|', '<C-W>v', { desc = 'Split window right', remap = true })

keymap('x', 'K', ":m '<-2<CR>gv-gv")
keymap('x', 'J', ":m '>+1<CR>gv-gv")

-- QUICKFIX
keymap('n', 'gq', vim.cmd.cnext, { desc = ' Next Quickfix' })
keymap('n', 'gQ', vim.cmd.cprevious, { desc = ' Prev Quickfix' })
keymap('n', 'dQ', function()
  vim.cmd.cexpr('[]')
end, { desc = ' Delete Quickfix List' })

-- -- OPTION TOGGLING
-- -- toggle inlay hints
-- keymap('n', '<leader>uh', function()
--   vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
-- end)

-- Resize windows using <ctrl> arrow keys
keymap('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height', silent = true })
keymap('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height', silent = true })
keymap('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width', silent = true })
keymap('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width', silent = true })

keymap('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })

-- Tabs
keymap('n', '<leader><tab>l', '<cmd>tablast<cr>', { desc = 'Last Tab' })
keymap('n', '<leader><tab>f', '<cmd>tabfirst<cr>', { desc = 'First Tab' })
keymap('n', '<leader><tab><tab>', '<cmd>tabnew<cr>', { desc = 'New Tab' })
keymap('n', '<leader><tab>]', '<cmd>tabnext<cr>', { desc = 'Next Tab' })
keymap('n', '<leader><tab>d', '<cmd>tabclose<cr>', { desc = 'Close Tab' })
keymap('n', '<leader><tab>[', '<cmd>tabprevious<cr>', { desc = 'Previous Tab' })
keymap('n', '[<tab>', '<cmd>tabprevious<cr>', { desc = 'Previous Tab', silent = true })
keymap('n', ']<tab>', '<cmd>tabnext<cr>', { desc = 'Next Tab', silent = true })

M = {}

function M.codeium_keymaps()
  local function local_map(key, func, desc, mode)
    if not mode then
      mode = 'i'
    end
    return { key, func, mode = mode, expr = true, silent = true, desc = desc }
  end
  return {
		-- stylua: ignore start
    local_map("<C-cr>", function() return vim.fn["codeium#Accept"]() end, "󰚩 Accept Suggestion"),
    local_map("<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, "󰚩 Cycle Suggestion"),
    local_map("<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, "󰚩 Cycle Suggestion"),
    local_map("<c-x>", function() return vim.fn["codeium#Clear"]() end, "󰚩 Clear Suggestion"),
    local_map("<leader>cd", function() return vim.fn["codeium#Chat"]() end, "󰚩 Chat", "n"),
    -- stylua: ignore end
  }
end

function M.gen_ai_keymaps()
  return {
    { '<leader>ia', mode = { 'n', 'v' }, '<cmd>Gen Ask<cr>', desc = 'A[I] [A]sk' },
    { '<leader>ig', mode = { 'n', 'v' }, '<cmd>Gen<cr>', desc = 'A[I] [G]en' },
    { '<leader>ic', mode = { 'n', 'v' }, '<cmd>Gen Change<cr>', desc = 'A[I] [C]hange' },
    { '<leader>io', mode = { 'n', 'v' }, '<cmd>Gen Change_Code<cr>', desc = 'A[I] Change C[o]de' },
    { '<leader>ih', mode = { 'n', 'v' }, '<cmd>Gen Chat<cr>', desc = 'A[I] C[h]at' },
    { '<leader>ie', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Code<cr>', desc = 'A[I] [E]nhance code' },
    { '<leader>iw', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Wording<cr>', desc = 'A[I] Enhance [W]ording' },
    { '<leader>is', mode = { 'n', 'v' }, '<cmd>Gen Enhance_Grammar_Spelling<cr>', desc = 'A[I] Enhance [G]rammar' },
    { '<leader>it', mode = { 'n', 'v' }, '<cmd>Gen Generate<cr>', desc = 'A[I] Genera[t]e' },
    { '<leader>ir', mode = { 'n', 'v' }, '<cmd>Gen Review_Code<cr>', desc = 'A[I] [R]eview Code' },
    { '<leader>iz', mode = { 'n', 'v' }, '<cmd>Gen Summarize<cr>', desc = 'A[I] Summari[z]e' },
  }
end

function M.codecompanion_keymaps()
  return {
    { '<leader>av', '<cmd>CodeCompanionChat Add<cr>', mode = { 'v' }, desc = 'Add Visual' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = 'InlineCode' },
    { '<leader>at', '<cmd>CodeCompanionChat Toggle<CR>', desc = 'AI Toggle', mode = { 'n', 'v' } },
    { '<leader>ac', '<cmd>CodeCompanionChat<CR>', desc = 'AI Chat', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionActions<CR>', desc = '[A]I [A]ctions', mode = { 'n', 'v' } },
    { '<leader>ao', ':CodeCompanionChat ollama<CR>', desc = 'Codecompanion: Ollama' },
  }
end

function M.generate_docs_keymaps()
  return {
    { '<leader>cn', ':Neogen<cr>', 'Generate Annotation' },
  }
end

function M.symbols_outline_keymaps()
  return {
    { '<leader>ss', '<cmd>Outline<cr>', desc = 'Toggle Outline' },
  }
end

function M.dap_keymaps()
		-- stylua: ignore start
  return {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
    { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition" },
    { "<leader>dj", function() require("dap").down() end, desc = "Down", },
    { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    { "<leader>dE", "<cmd>lua require('dapui').eval(vim.fn.input '[Expression] > ')<cr>", desc = "Evaluate Input" },
    { "<leader>dO", "<cmd>lua require('dap').step_out()<CR>", desc = "Step Out" },
    { "<leader>dP", "<cmd>lua require('dapui').float_element()<cr>", desc = "Float Element" },
    { "<leader>dR", "<cmd>lua require('dap').run_to_cursor()<cr>", desc = "Run to Cursor" },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes" },
    { "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>", desc = "Disconnect" },
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session" },
    { "<leader>dh", "<cmd>lua require('dap.ui.widgets').hover()<cr>", desc = "Hover Variables" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables" },
    { "<leader>di", "<cmd>lua require('dap').step_into()<CR>", desc = "Step Into" },
    { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<leader>do", "<cmd>lua require('dap').step_over()<CR>", desc = "Step Over" },
    { "<leader>dp", "<cmd>lua require('dap').pause()<cr>", desc = "Pause" },
    { "<leader>dq", function() require("dap").close() end, desc = "Quit" },
    { "<leader>dr", "<cmd>lua require('dap').repl.open()<cr>", desc = "Toggle REPL" },
    { "<leader>dv", "<cmd>lua require('dap.ui.widgets').preview()<cr>", desc = "Preview" },
    { "<leader>dx", "<cmd>lua require('dap').terminate()<cr>", desc = "Terminate" },
  }
  -- stylua: ignore end
end

function M.dap_ui_keymaps()
  return {
    {
      '<leader>dI',
      function()
        require('dapui').toggle({})
      end,
      desc = 'Dap UI',
    },
    {
      '<leader>de',
      function() -- Calling this twice to open and jump into the window.
        require('dapui').eval()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Evaluate expression',
    },
  }
end

function M.illuminate_keymaps()
  return {
		-- stylua: ignore start
    { "]]", function() require("illuminate").goto_next_reference(true) end, desc = "Next Reference" },
    { "[[", function() require("illuminate").goto_prev_reference(true) end, desc = "Prev Reference" },
    -- stylua: ignore end
  }
end

function M.terminal_keymaps()
  return {
    { '<leader>wt', '<cmd>ToggleTerm<cr>', desc = 'Toggle Terminal' },
    { '<leader>wf', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle Floating Terminal' },
    { '<leader>wh', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Toggle Horizontal Terminal' },
    { '<leader>wv', '<cmd>ToggleTerm size=80 direction=vertical<cr>', desc = 'Toggle Vertical Terminal' },
  }
end

function M.gitsigns_keymaps()
  return {
    { '<leader>gb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Toggle Git Blame' },
    { '<leader>gp', '<cmd>Gitsigns preview_hunk<cr>', desc = 'Preview Hunk' },
    { ']g', '<cmd>Gitsigns next_hunk<cr>', desc = 'Next Hunk' },
    { '[g', '<cmd>Gitsigns prev_hunk<cr>', desc = 'Prev Hunk' },
    { '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage Hunk' },
    { '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo Stage Hunk' },
    { '<leader>gr', '<cmd>Gitsigns reset_hunk<cr>', desc = 'Reset Hunk' },
    { '<leader>gR', '<cmd>Gitsigns reset_buffer<cr>', desc = 'Reset Buffer' },
  }
end

function M.neogit_keymaps()
  return {
    { '<leader>gn', '<cmd>Neogit<cr>', desc = 'Neogit' },
  }
end

function M.setup_coverage_keymaps()
  return {
    { '<leader>tcc', ':Coverage<CR>', desc = '[t]est [c]overage in gutter' },
    { '<leader>tcs', ':CoverageLoad<CR>:CoverageSummary<CR>', desc = '[t]est [C]overage summary' },
  }
end

function M.package_info_keymaps()
  return {
    { '<leader>pi', "<cmd>lua require('package-info').show()<cr>", desc = 'Package Info' },
    { '<leader>pd', "<cmd>lua require('package-info').delete()<cr>", desc = 'Delete Package' },
    { '<leader>pu', "<cmd>lua require('package-info').update()<cr>", desc = 'Update Package' },
    { '<leader>pU', "<cmd>lua require('package-info').update_all()<cr>", desc = 'Update All Packages' },
    { '<leader>pc', "<cmd>lua require('package-info').change_version()<cr>", desc = 'Change Package Version' },
    { '<leader>pi', "<cmd>lua require('package-info').install()<cr>", desc = 'Install Package' },
  }
end

return M
