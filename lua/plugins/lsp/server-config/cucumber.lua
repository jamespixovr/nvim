return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        cucumber_language_server = {
          cmd = { "cucumber-language-server", "--stdio" },
          root_dir = function(fname)
            local root_files = {
              { "*.sln",    "*.csproj", "node_modules/", "cucumber.json" },
              { "Makefile", "makefile", ".git" },
            }
            local util = require("lspconfig.util")
            for _, patterns in ipairs(root_files) do
              local root = util.root_pattern(unpack(patterns))(fname)
              if root then
                return root
              end
            end
          end,
          capabilities = { textDocument = { formatting = true } },
          settings = {
            cucumber = {
              features = {
                -- Cucumber-JVM
                "src/test/**/*.feature",
                -- Cucumber-Ruby Cucumber-Js, Behat, Behave
                "features/**/*.feature",
                -- Pytest-BDD
                "tests/**/*.feature",
                -- SpecFlow
                "*specs*/**/.feature",
                "**/Features/**/*.feature",
                -- Cypress
                "cypress/e2e/**/*.feature",
              },
              glue = {
                -- Cucumber-JVM
                "src/test/**/*.java",
                -- Cucumber-Js
                "features/**/*.ts",
                "features/**/*.js",
                "features/**/*.jsx",
                "features/**/*.tsx",
                -- Behave
                "features/**/*.php",
                -- Behat
                "features/**/*.py",
                -- Pytest-BDD
                "tests/**/*.py",
                -- Cucumber Rust
                "tests/**/*.rs",
                "features/**/*.rs",
                -- Cucumber-Ruby
                "features/**/*.rb",
                -- SpecFlow
                "*specs*/**/.cs",
                "**/Steps/**/*.cs",
                -- Cypress
                "cypress/e2e/**/*{.js,.ts}",
                "cypress/support/step_definitions/**/*{.js,.ts}",
              },
            },
          },
        },
      }
    }
  }
}
