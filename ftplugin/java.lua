local status, jdtls = pcall(require, "jdtls")
if not status then
	return
end

-- https://github.com/mfussenegger/nvim-jdtls#troubleshooting
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local home = os.getenv("HOME")
local workspace_dir = "/Users/jamo/Projects/eclipse/" .. project_name

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
	return
end
--
local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local bundles = {
	vim.fn.glob(
		home .. "/.local/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
	),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.local/vscode-java-test/server/*.jar"), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	cmd = {
		"/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xms2G",
		"-Xmx3G",
		"-javaagent:/Users/jamo/Projects/java_lib/lombok.jar",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-jar",
		"/Users/jamo/opt/jdt-language-server/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
		"-configuration",
		"/Users/jamo/opt/jdt-language-server/config_mac",
		"-data",
		workspace_dir,
	},

	on_attach = function(client, bufnr)
		require("modules.lsp.handlers").on_attach(client, bufnr)
		jdtls.setup_dap({ hotcodereplace = "auto" })
		jdtls.setup.add_commands()
		require("jdtls.dap").setup_dap_main_class_configs()
	end,
	capabilities = require("modules.lsp.handlers").common_capabilities(),
	-- 💀
	-- This is the default if not provided, you can remove it. Or adjust as needed.
	-- One dedicated LSP server & client will be started per unique root_dir
	root_dir = root_dir,

	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options
	settings = {
		java = {
			home = "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home/bin/java",
			eclipse = {
				downloadSources = true,
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
			references = {
				includeDecompiledSources = true,
			},
			format = { enabled = false },
			signatureHelp = { enabled = true },
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
			},
			contentProvider = { preferred = "fernflower" },
			extendedClientCapabilities = extendedClientCapabilities,
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				hashCodeEquals = {
					useJava7Objects = true,
				},
				useBlocks = true,
			},
			configuration = {
				runtimes = {
					--[[ {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/jdk1.8.0_101.jdk/Contents/Home",
          }, ]]
					{
						name = "JavaSE-11",
						path = "/Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home",
					},
					--[[ {
            name = "JavaSE-14",
            path = "/Library/Java/JavaVirtualMachines/adoptopenjdk-14.jdk/Contents/Home",
          }, ]]
					{
						name = "JavaSE-17",
						path = "/Library/Java/JavaVirtualMachines/jdk-17.0.2.jdk/Contents/Home",
					},
				},
			},
		},
	},

	flags = {
		allow_incremental_sync = true,
	},
	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	init_options = {
		-- bundles = {}
		bundles = bundles,
	},
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)

vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
)
vim.cmd(
	"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
)
vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
-- vim.cmd "command! -buffer JdtJol lua require('jdtls').jol()"
vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
-- vim.cmd "command! -buffer JdtJshell lua require('jdtls').jshell()"
