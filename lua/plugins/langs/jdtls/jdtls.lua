local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local cache_vars = {}

local root_markers = {
  '.git', -- These markers are preferred for the best root project recognition.
  'mvnw',
  'gradlew',

  -- Otherwise, you can use these root markers to identify your project also
  -- 'pom.xml',
  -- 'build.gradle',
}

local features = {
  -- change this to `true` to enable codelens
  codelens = false,

  -- change this to `true` if you have `nvim-dap`,
  -- `java-test` and `java-debug-adapter` installed
  debugger = true,
  -- change this to `true` if you have `spring-boot-tools` installed
  spring_boot_tools = true,
}

local function get_jdtls_paths()
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}

  path.workspace_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

  local jdtls_install = require('mason-registry').get_package('jdtls'):get_install_path()
  -- require custom mason registry
  local lombok_root = require('mason-registry').get_package('lombok-nightly'):get_install_path()

  path.lombok = lombok_root .. '/lombok.jar'
  path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

  if vim.fn.has('mac') == 1 then
    path.platform_config = jdtls_install .. '/config_mac'
  elseif vim.fn.has('unix') == 1 then
    path.platform_config = jdtls_install .. '/config_linux'
  elseif vim.fn.has('win32') == 1 then
    path.platform_config = jdtls_install .. '/config_win'
  end

  path.bundles = {}

  ---
  -- Include java-test bundle if present
  ---
  local java_test_path = require('mason-registry').get_package('java-test'):get_install_path()

  local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. '/extension/server/*.jar'), '\n')

  if java_test_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_test_bundle)
  end

  ---
  -- Include java-debug-adapter bundle if present
  ---
  local java_debug_path = require('mason-registry').get_package('java-debug-adapter'):get_install_path()

  local java_debug_bundle =
    vim.split(vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'), '\n')

  if java_debug_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_debug_bundle)
  end

  ---
  --- Include spring-boot-tools bundle if present
  ---
  local spring_extensions_bundle = require('spring_boot').java_extensions()
  if spring_extensions_bundle[1] ~= '' and features.spring_boot_tools then
    vim.list_extend(path.bundles, spring_extensions_bundle)
  end

  ---
  -- Useful if you're starting jdtls with a Java version that's
  -- different from the one the project uses.
  ---
  path.runtimes = {
    -- Note: the field `name` must be a valid `ExecutionEnvironment`,
    -- you can find the list here:
    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    --
    -- This example assume you are using sdkman: https://sdkman.io
    -- {
    --   name = 'JavaSE-17',
    --   path = vim.fn.expand('~/.sdkman/candidates/java/17.0.6-tem'),
    -- },
    -- {
    --   name = 'JavaSE-18',
    --   path = vim.fn.expand('~/.sdkman/candidates/java/18.0.2-amzn'),
    -- },
  }

  cache_vars.paths = path

  return path
end

local function enable_codelens(bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = bufnr,
    group = java_cmds,
    desc = 'refresh codelens',
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end

local function enable_debugger(_bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()
end

local function add_jdtls_keymaps()
  local status_ok, which_key = pcall(require, 'which-key')
  if not status_ok then
    return
  end

  local vopts = {
    remap = false, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
  }

  local vmappings = {
    mode = { 'v' },
    { '<leader>j', group = 'Java' },
    { '<leader>jc', "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>", desc = 'Extract Constant' },
    { '<leader>jm', "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>", desc = 'Extract Method' },
    { '<leader>jv', "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>", desc = 'Extract Variable' },
  }
  which_key.add(vmappings, vopts)
end

local function jdtls_on_attach(client, bufnr)
  add_jdtls_keymaps()

  if features.codelens then
    enable_codelens(bufnr)
  end

  if features.debugger then
    enable_debugger(bufnr)
  end

  if features.spring_boot_tools then
    require('spring_boot').init_lsp_commands()
  end
end

local basic_capabilities = {
  textDocument = {
    completion = {
      completionItem = {
        snippetSupport = true,
      },
    },
  },
}

local function jdtls_setup(event)
  local jdtls = require('jdtls')

  local path = get_jdtls_paths()

  local workspace_dir = path.workspace_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local project_root_dir = require('jdtls.setup').find_root(root_markers)

  if cache_vars.capabilities == nil then
    jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  end

  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  local cmd = {
    -- 💀
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. path.lombok,
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    '-jar',
    path.launcher_jar,

    -- 💀
    '-configuration',
    path.platform_config,

    -- 💀
    '-data',
    workspace_dir,
  }

  local lsp_settings = {
    java = {
      -- jdt = {
      --   ls = {
      --     -- You can define the java home especially for the JDTLS server here. In this way it doesn't matter what is your JAVA_HOME environmental variable anymore.
      --     -- Convenient to solve version mismatches for some old projects
      --     java = { home = vim.fn.expand('~/.sdkman/candidates/java/17.0.11-tem') },
      --     vmargs =
      --     "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx2G -Xms256m -Xlog:disable"
      --   }
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = path.runtimes,
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      -- saveActions = {
      --   organizeImports = true, -- Organize imports on save
      -- },
      -- inlayHints = {
      --   parameterNames = {
      --     enabled = 'all' -- literals, all, none
      --   }
      -- },
      format = {
        enabled = true,
        -- settings = {
        --   profile = 'asdf'
        -- },
      },
    },
    signatureHelp = {
      enabled = true,
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
      filteredTypes = {
        'com.sun.*',
        'io.micrometer.shaded.*',
        'java.awt.*',
        'jdk.*',
        'sun.*',
      },
    },
    contentProvider = {
      preferred = 'fernflower',
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      },
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  }

  -- Load the launch.json configuration
  require('dap.ext.vscode').load_launchjs()

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  jdtls.start_or_attach({
    cmd = cmd,
    settings = lsp_settings,
    on_attach = jdtls_on_attach,
    capabilities = basic_capabilities,
    root_dir = project_root_dir,
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      bundles = path.bundles,
    },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  group = java_cmds,
  pattern = { 'java' },
  desc = 'Setup jdtls',
  callback = jdtls_setup,
})
