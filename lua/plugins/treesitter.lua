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
      "nvim-treesitter/nvim-treesitter-textobjects",
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
        sync_install = false,
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
          "help",
          "html",
          "graphql",
          "go",
          "gosum",
          "gomod",
          "java",
          "ledger",
          "javascript",
          "json",
          "jsonc",
          "json5",
          "lua",
          "make",
          "markdown",
          "markdown_inline",
          "proto",
          "python",
          "query",
          "regex",
          "rust",
          "scss",
          "sql",
          "teal",
          "toml",
          "tsx",
          "typescript",
          "vue",
          "vim",
          "yaml",
          "svelte",
        },
        highlight = { enable = true, additional_vim_regex_highlighting = false, disable = is_disable },
        indent = { enable = true, disable = is_disable },
        context_commentstring = { enable = true, enable_autocmd = false, disable = is_disable },
        autopairs = { enable = true, disable = is_disable },
        autotag = { enable = true, disable = is_disable },
        playground = { enable = true, disable = is_disable },
        rainbow = { enable = true, disable = is_disable },
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
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end,
    config = function(_, opts)
      local parsers = require("nvim-treesitter.parsers")
      parsers.filetype_to_parsername.xml = "html"
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
