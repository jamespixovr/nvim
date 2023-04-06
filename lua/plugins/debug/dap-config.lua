local DEBUGGER_PATH = vim.fn.stdpath("data") .. '/lazy/vscode-js-debug'
local M = {}
local dap = require('dap')
local exts = {
  'javascript',
  'typescript',
  'javascriptreact',
  'typescriptreact',
  'vue',
  'svelte',
}

function M.setup()
  require("dap-vscode-js").setup({
    node_path = 'node',
    debugger_path = DEBUGGER_PATH,
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
  })
  for _i, ext in ipairs(exts) do
    dap.configurations[ext] = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node)',
        cwd = vim.fn.getcwd(),
        args = { '${file}' },
        sourceMaps = true,
        protocol = 'inspector',
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node with ts-node)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { '--loader', 'ts-node/esm' },
        runtimeExecutable = 'node',
        args = { '${file}' },
        sourceMaps = true,
        protocol = 'inspector',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        resolveSourceMapLocations = {
          "${workspaceFolder}/**",
          "!**/node_modules/**",
        },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Current File (pwa-node with deno)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
        runtimeExecutable = 'deno',
        attachSimplePort = 9229,
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with jest)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
        runtimeExecutable = 'node',
        args = { '${file}', '--coverage', 'false' },
        rootPath = '${workspaceFolder}',
        sourceMaps = true,
        console = 'integratedTerminal',
        internalConsoleOptions = 'neverOpen',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with vitest)',
        cwd = vim.fn.getcwd(),
        program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
        args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
        autoAttachChildProcesses = true,
        smartStep = true,
        console = 'integratedTerminal',
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
      },
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch Test Current File (pwa-node with deno)',
        cwd = vim.fn.getcwd(),
        runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
        runtimeExecutable = 'deno',
        attachSimplePort = 9229,
      },
      {
        type = 'pwa-chrome',
        request = 'attach',
        name = 'Attach Program (pwa-chrome = { port: 9222 })',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        port = 9222,
        webRoot = '${workspaceFolder}',
      },
      {
        type = 'node2',
        request = 'attach',
        name = 'Attach Program (Node2)',
        processId = require('dap.utils').pick_process,
      },
      {
        type = 'node2',
        request = 'attach',
        name = 'Attach Program (Node2 with ts-node)',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        skipFiles = { '<node_internals>/**' },
        port = 9229,
      },
      {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach Program (pwa-node)',
        cwd = vim.fn.getcwd(),
        processId = require('dap.utils').pick_process,
        skipFiles = { '<node_internals>/**' },
      },
      {
        type = "pwa-node",
        request = "launch",
        name = "Debug Jest Tests",
        -- trace = true, -- include debugger info
        runtimeExecutable = "node",
        runtimeArgs = {
          "./node_modules/jest/bin/jest.js",
          "--runInBand",
        },
        rootPath = "${workspaceFolder}",
        cwd = "${workspaceFolder}",
        console = "integratedTerminal",
        internalConsoleOptions = "neverOpen",
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach",
        processId = require 'dap.utils'.pick_process,
        cwd = "${workspaceFolder}",
      },
      {
        type = "pwa-chrome",
        name = "Launch Chrome",
        request = "launch",
        url = "http://localhost:3000",
      }
    }
  end
end

function M.vscodeExtensions()
  -- ## DAP `launch.json`
  require('dap.ext.vscode').load_launchjs(nil, {
    ['python'] = {
      'python',
    },
    ['pwa-node'] = {
      'javascript',
      'typescript',
    },
    ['node'] = {
      'javascript',
      'typescript',
    },
    ['cppdbg'] = {
      'c',
      'cpp',
    },
    ['dlv'] = {
      'go',
    },
  })
end

return M
