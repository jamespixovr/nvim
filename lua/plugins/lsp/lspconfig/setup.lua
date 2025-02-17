local M = {}

function M.setup(opts)
  local servers = opts.servers

  local function setup(server)
    local server_opts = servers[server] or {}

    if vim.g.cmploader == 'nvim-cmp' then
      server_opts.capabilities = require('cmp_nvim_lsp').default_capabilities()
    end

    if vim.g.cmploader == 'blink.cmp' then
      server_opts.capabilities = require('blink.cmp').get_lsp_capabilities(server_opts.capabilities)
    end

    if opts.setup[server] then
      if opts.setup[server](server, server_opts) then
        return
      end
    elseif opts.setup['*'] then
      if opts.setup['*'](server, server_opts) then
        return
      end
    end
    require('lspconfig')[server].setup(server_opts)
  end

  -- get all the servers that are available through mason-lspconfig
  local have_mason, mlsp = pcall(require, 'mason-lspconfig')
  local all_mslp_servers = {}
  if have_mason then
    all_mslp_servers = vim.tbl_keys(require('mason-lspconfig.mappings.server').lspconfig_to_package)
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

  require('plugins.lsp.lspconfig.attach')
  require('plugins.lsp.lspconfig.handlers')
end

return M
