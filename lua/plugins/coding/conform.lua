local function ensure_global_config_exists(filename, default_content)
  local config_path = (vim.fn.stdpath('config') .. '/.linter_configs/') .. filename
  if default_content == nil then
    return vim.fn.expand(config_path)
  end

  if vim.fn.filereadable(config_path) == 0 then
    vim.fn.mkdir((vim.fn.stdpath('config') .. '/.linter_configs/'), 'p')
    local file = io.open(config_path, 'w')
    if file then
      file:write(default_content)
      file:close()
    else
      vim.notify('Failed to create global config: ' .. config_path, vim.log.levels.ERROR)
    end
  end
end

-- Fallback function to find local markdownlint configuration files
local function get_markdownlint_config(ctx)
  local local_config = vim.fs.find({
    '.markdownlint.json',
    '.markdownlint.jsonc',
    '.markdownlint.yaml',
    '.markdownlint.yml',
  }, { upward = true, path = ctx.dirname })[1]

  if local_config then
    return local_config
  else
    -- Fallback to your global config directory path
    return ensure_global_config_exists('markdownlint.jsonc')
  end
end

return {
  'stevearc/conform.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  version = '*',
  cmd = { 'ConformInfo' },
  dependencies = { 'mason.nvim' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = false, timeout_ms = 5000, lsp_fallback = true })
      end,
      mode = { 'n', 'v' },
      desc = 'Format file or range (in visual mode)',
    },
  },
  config = function()
    local conform = require('conform')

    local web_formatter = function(bufnr)
      if conform.get_formatter_info('biome', bufnr).available then
        return { 'biome', 'biome-organize-imports' }
      else
        return { 'prettierd', 'prettier', stop_after_first = true }
      end
    end

    -- stop_after_first stops the chain at the first available formatter, so the
    -- prettier command has to be resolved before the organize step is prepended
    local prettier_command = function(bufnr)
      return conform.get_formatter_info('prettierd', bufnr).available and 'prettierd' or 'prettier'
    end

    -- biome's assist already organizes imports, so only the prettier path needs it
    local js_formatter = function(bufnr)
      if conform.get_formatter_info('biome', bufnr).available then
        return web_formatter(bufnr)
      end
      return { 'ts-organize-imports', prettier_command(bufnr) }
    end

    local function edits_for_uri(edit, uri)
      if edit.changes and edit.changes[uri] then
        return edit.changes[uri]
      end
      for _, change in ipairs(edit.documentChanges or {}) do
        if change.textDocument and change.textDocument.uri == uri then
          return change.edits
        end
      end
    end

    local function apply_text_edits_to_copy(encoding, lines, edits)
      local copy = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(copy, 0, -1, false, lines)
      vim.lsp.util.apply_text_edits(edits, copy, encoding)
      local updated = vim.api.nvim_buf_get_lines(copy, 0, -1, false)
      vim.api.nvim_buf_delete(copy, { force = true })
      return updated
    end

    -- bounded so a slow server cannot eat the whole format_on_save budget (500ms)
    local LSP_TIMEOUT_MS = 150

    local function resolve_action(client, action, bufnr)
      if not client:supports_method('codeAction/resolve', bufnr) then
        return action
      end
      local resolved = client:request_sync('codeAction/resolve', action, LSP_TIMEOUT_MS, bufnr)
      return resolved and resolved.result
    end

    local function organize_imports(bufnr, lines)
      local clients = vim.lsp.get_clients({ bufnr = bufnr, method = 'textDocument/codeAction' })
      if #clients == 0 then
        return lines
      end

      local uri = vim.uri_from_bufnr(bufnr)
      local results = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', {
        textDocument = { uri = uri },
        range = { start = { line = 0, character = 0 }, ['end'] = { line = 0, character = 0 } },
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
      }, LSP_TIMEOUT_MS) or {}

      for _, client in ipairs(clients) do
        for _, action in ipairs(results[client.id] and results[client.id].result or {}) do
          local resolved = action.edit and action or resolve_action(client, action, bufnr)
          local edits = resolved and resolved.edit and edits_for_uri(resolved.edit, uri)
          if edits then
            return apply_text_edits_to_copy(client.offset_encoding, lines, edits)
          end
        end
      end

      return lines
    end

    conform.setup({
      format = {
        timeout_ms = 3000,
        async = true,
        quiet = false,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        cs = { 'csharpier' },
        csproj = { 'csharpier' },
        sln = { 'csharpier' },
        slnx = { 'csharpier' },
        cucumber = { 'reformat-gherkin' },
        go = { 'goimports', 'gci', 'gofumpt', 'golines' },
        -- web languages
        css = web_formatter,
        graphql = web_formatter,
        handlebars = { 'prettier' },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        javascript = js_formatter,
        javascriptreact = js_formatter,
        json = web_formatter,
        json5 = { 'biome' },
        jsonc = { 'biome' },
        scss = { 'prettierd' },
        typescript = js_formatter,
        typescriptreact = js_formatter,

        lua = { 'stylua' },
        markdown = { 'markdownlint', 'markdown-toc', stop_after_first = true },
        python = { 'ruff_fix', 'ruff_organize_imports' },
        sh = { 'shfmt' },
        sql = { 'sleek' },
        xml = { 'xmlformatter' },
        yaml = { 'yamlfmt', 'trim_whitespace' },
        zsh = { 'shell-home', 'shellcheck' },
        ['*'] = { 'trim_whitespace' },
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        local ignore_filetypes = {}
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match('/node_modules/') then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters = {
        biome = {
          args = function(self, ctx)
            local local_config = vim.fs.find({ 'biome.json', 'biome.jsonc' }, {
              upward = true,
              path = ctx.dirname,
            })[1]

            local args = { 'format', '--stdin-file-path', '$FILENAME' }

            if not local_config then
              local global_config_path = ensure_global_config_exists('biome.json')
              table.insert(args, '--config-path=' .. global_config_path)
            end

            return args
          end,
        },
        yamlfmt = {
          -- Dynamically inject global yamlfmt settings if no local configuration file is found
          args = function(self, ctx)
            local local_config = vim.fs.find({ '.yamlfmt', 'yamlfmt.yaml', 'yamlfmt.yml' }, {
              upward = true,
              path = ctx.dirname,
            })[1]

            local args = { '-in' }

            if not local_config then
              local global_config = ensure_global_config_exists('yamlfmt.yaml')
              vim.list_extend(args, { '-conf', global_config })
            end

            return args
          end,
        },
        markdownlint = {
          command = 'markdownlint',
          stdin = false,
          args = function(self, ctx)
            -- Evaluates dynamically to use the project local configuration or global backup
            local config_path = get_markdownlint_config(ctx)
            return { '--fix', '--config', config_path, '$FILENAME' }
          end,
        },
        shellcheck = {
          args = "'$FILENAME' --format=diff --shell=bash | patch -p1 '$FILENAME'",
        },
        ['shell-home'] = {
          format = function(_self, _ctx, lines, callback)
            local updated = vim.tbl_map(function(line)
              return line:gsub('/Users/%a+', '$HOME'):gsub('([^/\\])~/', '%1$HOME/')
            end, lines)
            callback(nil, updated)
          end,
        },
        sqlfluff = {
          args = { 'format', '--dialect=ansi', '-' },
        },
        goimports = {
          args = { '-srcdir', '$FILENAME' },
        },
        gci = {
          args = { 'write', '--skip-generated', '-s', 'standard', '-s', 'default', '--skip-vendor', '$FILENAME' },
        },
        gofumpt = {
          prepend_args = { '-extra', '-w', '$FILENAME' },
          stdin = false,
        },
        golines = {
          prepend_args = { '--base-formatter=gofumpt', '--ignore-generated', '--tab-len=1', '--max-len=120' },
        },
        xmlformatter = {
          prepend_args = {
            '--indent',
            '2',
          },
        },
        ['ts-add-missing-imports'] = {
          format = function(_self, ctx, _lines, callback)
            vim.lsp.buf.code_action({
              context = { only = { 'source.addMissingImports.ts' } },
              apply = true,
            })
            vim.defer_fn(function()
              local out_lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, true)
              callback(nil, out_lines)
            end, 80)
          end,
        },
        ['ts-organize-imports'] = {
          format = function(_self, ctx, lines, callback)
            callback(nil, organize_imports(ctx.buf, lines))
          end,
        },
      },
    })

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true
      else
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save (bang == current file only)',
      bang = true,
    })
    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
}
