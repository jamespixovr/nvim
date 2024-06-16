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
  if pcall(require, "inc_rename") then
    vim.api.nvim_feedkeys(":IncRename " .. vim.fn.expand("<cword>"), "n", false)
  else
    vim.lsp.buf.rename()
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ctx)
    local bufnr = ctx.buf

    local function map(lhs, rhs, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    local client = vim.lsp.get_client_by_id(ctx.data.client_id)
    assert(client, "No client found")

    if client.name == "copilot" then
      return
    end

    if client.name == "gopls" then
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

    if client.name == "ruff_lsp" then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end

    map("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", "[LSP] Go implementation")

    if client.supports_method(methods.textDocument_definition) then
      -- map("n", "gd", "<cmd>Glance definitions<CR>", { buffer = bufnr, desc = "[LSP] Go definitions" })
      map("gD", "<cmd>FzfLua lsp_definitions<cr>", "Peek definition")
      map("gd", function()
        require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
      end, "Go to definition")
    end

    map("gr", "<cmd>Glance references<CR>", "[LSP] Go references")
    map("gI", "<cmd>Glance implementations<CR>", "[LSP] Go implementation")
    map("gt", "<cmd>Glance type_definitions<cr>", "Goto Type Definition")

    map("K", "<cmd>lua vim.lsp.buf.hover()<CR>", "[LSP] Hover")

    if client.supports_method(methods.textDocument_signatureHelp) then
      map("<C-k>", function()
        -- Close the completion menu first (if open).
        local cmp = require("cmp")
        if cmp.visible() then
          cmp.close()
        end

        vim.lsp.buf.signature_help()
      end, "Signature help", "i")
    end

    map("gl", "<cmd>lua vim.diagnostic.open_float(0,{border='rounded'})<CR>", "[LSP] Show diagnostics")

    map("[d", diagnostic_goto(true), "Next Diagnostic")
    map("]d", diagnostic_goto(false), "Next Diagnostic")

    map("<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", "[LSP] Set loclist")

    map("<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "[W]orkspace [A]dd Folder")
    map("<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", "[W]orkspace [R]emove Folder")
    map(
      "<leader>wl",
      "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
      "[W]orkspace [L]ist Folders"
    )
    -- map("gy", vim.lsp.buf.declaration, "[LSP] Go declaration")
    map("gy", "<cmd>FzfLua lsp_typedefs<cr>", "Go to type definition")

    map("<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "Document symbols")
    map("<leader>fS", function()
      -- Disable the grep switch header.
      require("fzf-lua").lsp_live_workspace_symbols({ no_header_i = true })
    end, "Workspace symbols")

    if client.supports_method(methods.textDocument_codeAction) then
      map("<leader>ca", vim.lsp.buf.code_action, "Code Actions", { "n", "v" })
    end

    if client.supports_method(methods.textDocument_rename) then
      -- map("<leader>cr", vim.lsp.buf.rename, "Rename")
      map("<leader>cr", rename, "[R]ename")
    end

    map("<leader>ci", "<cmd>LspInfo<cr>", "Lsp Info")
    map("<leader>ch", vim.lsp.codelens.refresh, "CodeLens Refresh")
    map("<leader>cl", vim.lsp.codelens.run, "[C]ode[L]ens Run")
  end,
})
