---@type vim.lsp.Config
return {
  cmd = { 'cucumber-language-server', '--stdio' },
  filetypes = { 'cucumber' },
  root_markers = { '.git' },
  capabilities = { textDocument = { formatting = true } },
  settings = {
    cucumber = {
      features = {
        -- Cucumber-JVM
        'src/test/**/*.feature',
        -- Cucumber-Ruby Cucumber-Js, Behat, Behave
        'features/**/*.feature',
        -- Pytest-BDD
        'tests/**/*.feature',
        -- SpecFlow
        '*specs*/**/.feature',
        '**/Features/**/*.feature',
        -- Cypress
        'cypress/e2e/**/*.feature',
      },
      glue = {
        -- DEFAULTS
        -- Cucumber-JVM
        'src/test/**/*.java',
        -- Cucumber-Js
        'features/**/*.ts',
        'features/**/*.tsx',
        'features/**/*.js',
        'features/**/*.jsx',
        'step-definitions/**/*.ts',
        -- TODO: Modify regex pattern to match `feature(s)`
        'test/feature/**/*.ts',
        'test/features/**/*.ts',
        -- Behat
        'features/**/*.php',
        -- Behave
        'features/**/*.py',
        -- Pytest-BDD
        'tests/**/*.py',
        -- Cucumber Rust
        'tests/**/*.rs',
        'features/**/*.rs',
        -- Cucumber-Ruby
        'features/**/*.rb',
        -- SpecFlow
        '*specs*/**/*.cs',
        '**/Steps/**/*.cs',
        -- Godog
        'features/**/*_test.go',
        -- Cypress
        'cypress/e2e/**/*{.js,.ts}',
        'cypress/support/step_definitions/**/*{.js,.ts}',
      },
    },
  },
}
