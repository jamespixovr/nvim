local dap = require("dap")

if not dap.adapters["pwa-node"] then
  require("dap").adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter" .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
end

if not dap.adapters["node"] then
  dap.adapters["node"] = function(cb, config)
    if config.type == "node" then
      config.type = "pwa-node"
    end
    local nativeAdapter = dap.adapters["pwa-node"]
    if type(nativeAdapter) == "function" then
      nativeAdapter(cb, config)
    else
      cb(nativeAdapter)
    end
  end
end

for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
  if not dap.configurations[language] then
    dap.configurations[language] = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch Current File (pwa-node)",
        cwd = vim.fn.getcwd(),
        args = { "${file}" },
        sourceMaps = true,
        protocol = "inspector",
        runtimeExecutable = "npm",
        runtimeArgs = {
          "run-script", "dev"
        },
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        }

      },
    }
  end
end
