---@diagnostic disable: need-check-nil
-- List active linters for the current filetype
local function ListActiveLinters()
  local ok, lint = pcall(require, 'lint')
  if not ok then
    print('nvim-lint is not available.')
    return
  end

  local linters = lint.linters_by_ft[vim.bo.filetype]
  if linters then
    print("Active linters for filetype '" .. vim.bo.filetype .. "':")
    for _, linter in ipairs(linters) do
      print(linter)
    end
  else
    print("No active linters for filetype '" .. vim.bo.filetype .. "'.")
  end
end

return {
  {
    'mfussenegger/nvim-lint',
    event = 'BufReadPost',
    -- event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      {
        '<leader>bl',
        function()
          require('lint').try_lint()
        end,
        desc = '[L]int buffer',
      },
      { '<leader>ct', ListActiveLinters, desc = 'Linters' },
    },
    opts = {
      ---@type table<string,table>
      linters = {},
      linters_by_ft = {
        python = { 'ruff' },
        dockerfile = { 'hadolint' },
        go = { 'golangcilint' },
        -- go = { 'golangcilint', 'fieldalignment', 'staticcheck' },
        htmldjango = { 'djlint' },
        lua = { 'selene' },
        sh = { 'shellcheck' },
        -- markdown = { 'markdownlint' },
        markdown = { 'markdownlint-cli2' },
        css = { 'stylelint' },
        scss = { 'stylelint' },
        less = { 'stylelint' },
        sql = { 'sqlfluff' },
        ['yaml.ghaction'] = { 'actionlint' },
        yaml = { 'yamllint' },
      },
    },
    config = function(_, opts)
      -- == config markdownlint ==
      -- WARN: change to the path to markdownlint config file
      local markdownlintrc = vim.fn.expand(vim.fn.stdpath('config') .. '/.linter_configs/markdownlint.jsonc')
      -- local markdownlintrc = vim.fn.expand('~') .. '/.markdownlint.jsonc'
      local markdownlint = require('lint').linters['markdownlint-cli2']
      markdownlint.args = {
        '--config',
        markdownlintrc,
      }

      local M = {}
      local lint = require('lint')
      for name, linter in pairs(opts.linters) do
        if type(linter) == 'table' and type(lint.linters[name]) == 'table' then
          lint.linters[name] = vim.tbl_deep_extend('force', lint.linters[name], linter)
        else
          lint.linters[name] = linter
        end
      end

      lint.linters_by_ft = opts.linters_by_ft
      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      lint.linters.fieldalignment = {
        name = 'fieldalignment',
        cmd = 'fieldalignment',
        args = { '-json' },
        stdin = false,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = function(output, bufnr)
          if output == '' then
            return {}
          end
          local decoded = vim.json.decode(output, { luanil = { object = true, array = true } })
          local diagnostics = {}
          for _, issues in pairs(decoded) do
            for _, issue_list in pairs(issues) do
              for _, issue in ipairs(issue_list) do
                local pos = issue.posn
                local _, lnum, col = pos:match('^(.+):(%d+):(%d+)$')
                lnum = tonumber(lnum) or 1
                col = tonumber(col) or 1
                local message = issue.message
                local suggested_fix = ''
                if issue.suggested_fixes and #issue.suggested_fixes > 0 then
                  local fix = issue.suggested_fixes[1]
                  if fix.edits and #fix.edits > 0 then
                    suggested_fix = fix.edits[1].new
                    suggested_fix = suggested_fix:gsub('\n', '\n\t'):gsub('\t', '  ')
                    message = message .. '\nSuggested struct:\n' .. suggested_fix
                  end
                end
                table.insert(diagnostics, {
                  bufnr = bufnr,
                  lnum = lnum - 1,
                  col = col - 1,
                  end_lnum = lnum - 1,
                  end_col = col - 1,
                  severity = vim.diagnostic.severity.WARN,
                  message = message,
                  source = 'fieldalignment',
                })
              end
            end
          end
          return diagnostics
        end,
      }

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft['_'] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft['*'] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            print('Linter not found: ' .. name, vim.log.levels.WARN)
          end
          return linter and not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = M.debounce(100, M.lint),
        -- callback = function()
        --   if vim.opt_local.modifiable:get() then
        --     lint.try_lint()
        --   end
        -- end,
      })
    end,
  },
}
