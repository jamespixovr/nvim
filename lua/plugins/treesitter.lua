return {
  { "windwp/nvim-ts-autotag", ft = { "html", "xml", "javascriptreact", "typescriptreact" } },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    lazy = false,
    config = true,
  },
  {
    --- Treesitter
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    version = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
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
          "gomod",
          "gosum",
          "gowork",
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
        highlight = { enable = true, additional_vim_regex_highlighting = false },
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
