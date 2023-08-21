local M = {}
local format = require("plugins.lsp.format").format


function M.always_attach()
  vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
  vim.keymap.set("n", "<leader>xd", "<cmd>Telescope diagnostics<cr>", { desc = "Telescope Diagnostics" })
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
  vim.keymap.set("n", "gD", "<cmd>Telescope lsp_declarations<cr>", { desc = "Goto Declaration" })
  vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto Type Definition" })
  vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  vim.keymap.set({ "n", "v" }, "<leader>cf", format, { desc = "Format Document" })
  vim.keymap.set("n", "<leader>ch", vim.lsp.codelens.refresh, { desc = "CodeLens Refresh" })
  vim.keymap.set("n", "<leader>ci", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
  vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, { desc = "CodeLens Run" })
  vim.keymap.set("n", "<leader>cr", M.rename, { desc = "Rename" })

  vim.keymap.set("n", "[d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
  vim.keymap.set("n", "]d", M.diagnostic_goto(false), { desc = "Next Diagnostic" })
end

function M.rename()
  if pcall(require, "inc_rename") then
    vim.api.nvim_feedkeys(":IncRename " .. vim.fn.expand("<cword>"), "n", false)
  else
    vim.lsp.buf.rename()
  end
end

function M.diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end

return M
