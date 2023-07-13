return {
  { "windwp/nvim-ts-autotag", ft = { "html", "xml", "javascriptreact", "typescriptreact" } },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = true,
  },
  {
    --- Treesitter
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-treesitter/nvim-tree-docs",
      "windwp/nvim-ts-autotag",
      "mfussenegger/nvim-ts-hint-textobject",
      "JoosepAlviste/nvim-ts-context-commentstring"
    },
    opts = function()
      local function is_disable(_, bufnr)
        return bufnr and vim.api.nvim_buf_line_count(bufnr) > 5000
      end
      return {
        ignore_install = { "help" },
        ensure_installed = {
          "awk",
          "bash",
          "c",
          "c_sharp",
          "cpp",
          "css",
          "diff",
          "dockerfile",
          "fennel",
          "graphql",
          "go",
          "gosum",
          "gomod",
          "html",
          "java",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
          "json5",
          "ledger",
          "lua",
          "luap",   -- lua patterns
          "luadoc", -- lua annotations
          "make",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "query",
          "regex",
          "ron",
          "rust",
          "scss",
          "sql",
          "teal",
          "toml",
          "tsx",
          "typescript",
          "vue",
          "vim",
          "vimdoc",
          "yaml",
          "svelte",
        },
        auto_install = true, -- install missing parsers when entering a buffer
        highlight = { enable = true, additional_vim_regex_highlighting = false, disable = is_disable },
        indent = { enable = true, disable = is_disable },
        context_commentstring = { enable = true, enable_autocmd = false, disable = is_disable },
        autopairs = { enable = true, disable = is_disable },
        autotag = { enable = true, disable = is_disable },
        playground = { enable = true, disable = is_disable },
        matchup = { enable = true, disable = is_disable },
        incremental_selection = {
          enable = true,
          disable = is_disable,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<nop>",
            node_decremental = "<bs>",
          },
        },
        -- TREESITTER PLUGINS
        rainbow = { enable = true, disable = is_disable },
        tree_docs = {
          enable = true,
          spec_config = {
            jsdoc = {
              slots = {
                class = { author = true },
              },
              processors = {
                author = function()
                  return " * @author James Amo"
                end,
              },
            },
          },
        },
        refactor = {
          highlight_definitions = {
            enable = true,
            clear_on_cursor_move = false, -- set to true with a very low updatetime
          },
          highlight_current_scope = { enable = false },
          smart_rename = {
            enable = true,
            keymaps = {
              -- not using the same hotkey as LSP rename to prevent overwriting it
              smart_rename = "<leader>v",
            },
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
  },
}
