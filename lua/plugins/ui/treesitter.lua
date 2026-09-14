local ensure_installed = {
  'awk',
  'bash',
  'c',
  'c_sharp',
  'cpp',
  'css',
  'diff',
  'dockerfile',
  'fennel',
  'graphql',
  'go',
  'gomod',
  'gosum',
  'gowork',
  'html',
  'http',
  'hurl',
  'java',
  'javascript',
  'jsdoc',
  'json',
  -- 'jsonc',
  'json5',
  'ledger',
  'lua',
  'luap', -- lua patterns
  'luadoc', -- lua annotations
  'make',
  'markdown',
  'markdown_inline',
  'ninja',
  'proto',
  'python',
  'regex',
  'rst',
  'ron',
  'ruby', -- used by `Brewfile`
  'rust',
  'scss',
  'sql',
  -- 'teal',
  'toml',
  'tsx',
  'typescript',
  'vue',
  'yaml',
  'svelte',
  -- SPECIAL FILETYPES
  'diff',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitattributes',
  'gitcommit',
  'gitignore',
  'just',
  'query', -- treesitter query files (.scm)
  'requirements', -- python's `requirements.txt`
  'vimdoc', -- `:help` files
  'vim',
}
return {
  {
    --- Treesitter
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    event = { 'BufRead', 'BufNewFile', 'BufReadPost', 'BufWritePre', 'VeryLazy' },
    cmd = {
      'TSInstall',
      'TSUninstall',
      'TSUpdate',
      'TSUpdateSync',
      'TSInstallInfo',
      'TSInstallSync',
      'TSInstallFromGrammar',
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          local filetype = args.match
          local lang = vim.treesitter.language.get_lang(filetype)
          if not lang then
            return
          end
          ---@diagnostic disable-next-line: param-type-mismatch
          if vim.treesitter.language.add(lang) then
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldmethod = 'expr'

            -- Only enable indentexpr if the lang contains queries for indents
            -- Otherwise it will just mess everything up in C# at least
            -- local lang = vim.treesitter.language.get_lang(vim.bo.ft) or vim.bo.ft
            if vim.treesitter.query.get(lang, 'indents') then
              vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            end
          end
        end,
      })
    end,
    config = function()
      local treesitter = require('nvim-treesitter')
      treesitter.install(ensure_installed)

      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('dotfiles.treesitter', { clear = true }),
        callback = function(args)
          if not treesitter then
            return
          end

          local ignored_fts = {
            'codecompanion',
            'csv',
            'prompt',
            'snacks_dashboard',
            'snacks_input',
            'snacks_picker_input',
          }

          if vim.tbl_contains(ignored_fts, args.match) then
            return
          end

          pcall(vim.treesitter.start, args.buf)
        end,
      })
      vim.treesitter.language.register('json', { 'jsonc' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    opts = {
      select = {
        enable = true,
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
      },
      move = {
        enable = true,
        set_jumps = true,
      },

      include_surrounding_whitespace = true,
    },
    keys = vim
      .iter(vim
        .iter({
          select = {
            ['af'] = { query = '@function.outer', desc = 'function outer' },
            ['if'] = { query = '@function.inner', desc = 'function inner' },
            ['ac'] = { query = '@class.outer', desc = 'class outer' },
            ['ic'] = { query = '@class.inner', desc = 'class inner' },

            ['aj'] = { query = '@cell', desc = 'cell outer' },
            ['ij'] = { query = '@cellcontent', desc = 'cell inner' },

            ['as'] = { query = '@local.scope', desc = 'locals' },
          },
          move = {
            goto_next_start = {
              [']f'] = { query = '@function.outer', desc = 'function start' },
              [']c'] = { query = '@class.outer', desc = 'class start' },
              [']z'] = { query = '@fold', query_group = 'folds', desc = 'fold' },
              [']j'] = {
                query = { '@cellseparator.code', '@cellseparator.markdown', '@cellseparator.raw' },
                desc = 'cell separator',
              },
            },
            goto_previous_start = {
              ['[f'] = { query = '@function.outer', desc = 'function start' },
              ['[c'] = { query = '@class.outer', desc = 'class start' },
              ['[z'] = { query = '@fold', query_group = 'folds', desc = 'fold' },
              ['[j'] = {
                query = { '@cellseparator.code', '@cellseparator.markdown', '@cellseparator.raw' },
                desc = 'cell separator',
              },
            },
          },
        })
        :map(function(feat, v)
          if feat == 'select' then
            return vim
              .iter(v)
              :map(function(key, opts)
                return {
                  key,
                  function()
                    require('nvim-treesitter-textobjects.select').select_textobject(opts.query, 'textobjects')
                  end,
                  desc = opts.desc,
                  mode = { 'x', 'o' },
                }
              end)
              :totable()
          end
          if feat == 'move' then
            local bb = vim
              .iter(pairs(v))
              :map(function(func, maps)
                return vim
                  .iter(maps)
                  :map(function(key, opts)
                    return {
                      key,
                      function()
                        require('nvim-treesitter-textobjects.move')[func](opts.query, 'textobjects')
                      end,
                      desc = opts.desc,
                      mode = { 'n', 'x', 'o' },
                    }
                  end)
                  :totable()
              end)
              :totable()
            return vim.iter(bb):flatten():totable()
          end
          return {}
        end)
        :totable())
      :flatten()
      :totable(),
  },
  'JoosepAlviste/nvim-ts-context-commentstring', -- Smart commenting in multi language files - Enabled in Treesitter file
  -- Tags
  -- Autoclose and autorename HTML and Vue tags
  { 'windwp/nvim-ts-autotag', event = 'InsertEnter', config = true },

  {
    'windwp/nvim-autopairs', -- Autopair plugin
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      enable_moveright = true,
      disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'snacks_picker_input', 'codecompanion' },
      fast_wrap = { map = '<c-e>' },
    },
    config = function(_, opts)
      local autopairs = require('nvim-autopairs')

      autopairs.setup(opts)

      local Rule = require('nvim-autopairs.rule')
      local ts_conds = require('nvim-autopairs.ts-conds')

      autopairs.add_rules({
        Rule('{{', '  }', 'vue'):set_end_pair_length(2):with_pair(ts_conds.is_ts_node('text')),
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    enabled = true,
    opts = { mode = 'cursor', max_lines = 3, multiwindow = true },
  },
  {
    'abecodes/tabout.nvim', -- Tab out from parenthesis, quotes, brackets...
    opts = {
      tabkey = '<Tab>', -- key to trigger tabout, set to an empty string to disable
      backwards_tabkey = '<S-Tab>', -- key to trigger backwards tabout, set to an empty string to disable
      completion = true, -- We use tab for completion so set this to true
    },
  },
}
