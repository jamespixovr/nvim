return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        lua_ls = {
          single_file_support = true,
          settings = {
            Lua = {
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
                enable = true,
                showWord = "Disable",
              },
              diagnostics = {
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
                globals = { "vim" },
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              hint = {
                enable = true, -- enabled inlay hints
                setType = true,
                arrayIndex = "Disable",
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.stdpath("config") .. "/lua"] = true,
                },
              },
            },
          },
        }
      },
    },
  }
}
