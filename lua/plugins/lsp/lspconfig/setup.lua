---@diagnostic disable: need-check-nil

local settings = require("settings")

local M = {}

function M.setup(opts)
  -- diagnostics
  -- options for vim.diagnostic.config()
  local diagnostics = {
    underline = true,
    signs = { active = settings.icons.diagnostics },
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = "●", source = "if_many" },
    severity_sort = true,
    float = {
      show_header = true,
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      prefix = "",
    },
  }

  for name, icon in pairs(settings.icons.diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end


  if type(diagnostics.virtual_text) == "table" and diagnostics.virtual_text.prefix == "icons" then
    diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
        or function(diagnostic)
          local icons = settings.icons.diagnostics
          for d, icon in pairs(icons) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
  end



  vim.diagnostic.config(vim.deepcopy(diagnostics))

  local servers = opts.servers

  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities(),
    opts.capabilities or {}
  ) or {}

  local function setup(server)
    local server_opts = vim.tbl_deep_extend("force", { capabilities = vim.deepcopy(capabilities), },
      servers[server] or {})

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup["*"] then
      if opts.setup["*"](server, server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(server_opts)
  end

  -- get all the servers that are available thourgh mason-lspconfig
  local have_mason, mlsp = pcall(require, "mason-lspconfig")
  local all_mslp_servers = {}
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  end

  local ensure_installed = {} ---@type string[]
  for server, server_opts in pairs(servers) do
    if server_opts then
      server_opts = server_opts == true and {} or server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end

  if have_mason then
    mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
  end
  require "plugins.lsp.lspconfig.attach"
  require "plugins.lsp.lspconfig.handlers"
end

return M
