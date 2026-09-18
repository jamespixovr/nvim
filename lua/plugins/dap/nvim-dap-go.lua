return {
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = {
      { 'mfussenegger/nvim-dap' },
      { 'rcarriga/nvim-dap-ui' },
      { 'nvim-neotest/nvim-nio' },
    },
    config = function()
      local dap_go = require('dap-go')
      local dap = require('dap')
      -- local dap_ui = require('dapui')

      local function get_current_function_name()
        local current_node = vim.treesitter.get_node()
        if not current_node then
          return ''
        end

        local expr = current_node

        while expr do
          if expr:type() == 'function_declaration' or expr:type() == 'method_declaration' then
            break
          end
          expr = expr:parent()
        end
        if not expr then
          return ''
        end

        local name = expr:field('name')[1]
        return name and vim.treesitter.get_node_text(name, 0) or ''
      end

      vim.keymap.set('n', '<leader>cf', get_current_function_name, { desc = 'test capture function' })

      -- Helper function to detect build tags in current file
      local function get_build_tags()
        local file_path = vim.fn.expand('%:p')
        local file = io.open(file_path, 'r')
        if not file then
          return ''
        end

        -- Read first 10 lines to find build tags
        local tags = {}
        for i = 1, 10 do
          local line = file:read('*l')
          if not line then
            break
          end

          -- Match //go:build tag1,tag2 or // +build tag1 tag2
          local build_constraint = line:match('^//go:build%s+(.+)') or line:match('^//%s*%+build%s+(.+)')
          if build_constraint then
            -- Parse tags (handle AND, OR, NOT logic)
            for tag in build_constraint:gmatch('[%w_]+') do
              table.insert(tags, tag)
            end
          end
        end
        file:close()

        if #tags > 0 then
          return '-tags=' .. table.concat(tags, ',')
        end
        return ''
      end

      -- Helper function to get test function name using treesitter
      local function get_go_test_name()
        local current_node = vim.treesitter.get_node()
        if not current_node then
          return nil
        end

        -- Walk up the tree to find function_declaration
        local expr = current_node
        while expr do
          if expr:type() == 'function_declaration' then
            -- Get the function name
            for child in expr:iter_children() do
              if child:type() == 'identifier' then
                local name = vim.treesitter.get_node_text(child, 0)
                -- Only return if it's a test function (starts with Test)
                if name:match('^Test') then
                  return name
                end
              end
            end
          end
          expr = expr:parent()
        end

        -- Fallback: try to get word under cursor if it looks like a test
        local word = vim.fn.expand('<cword>')
        if word:match('^Test') then
          return word
        end

        return nil
      end

      -- Go test debugging - filetype specific
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'go',
        callback = function()
          vim.keymap.set('n', '<leader>dt', function()
            local test_name = get_go_test_name()
            local build_flags = get_build_tags()

            local config = {
              type = 'go',
              name = 'Debug Test',
              request = 'launch',
              mode = 'test',
              program = '${fileDirname}',
              dlvCwd = '${fileDirname}',
              showLog = true,
              outputMode = 'remote',
            }

            -- Add test filter if we found a test name
            if test_name and test_name ~= '' then
              config.args = { '-test.run', '^' .. test_name .. '$', '-test.v' }
              config.name = 'Debug Test: ' .. test_name
            else
              -- Run all tests in the file if no specific test found
              config.args = { '-test.v' }
              config.name = 'Debug All Tests'
              vim.notify('No test function found under cursor, running all tests', vim.log.levels.WARN)
            end

            -- Only add buildFlags if tags were found
            if build_flags ~= '' then
              config.buildFlags = build_flags
            end

            dap.run(config)
          end, { desc = 'debug go test (auto-detect tags)', buffer = true })
        end,
      })

      -- List and switch between active debug sessions
      vim.keymap.set('n', '<leader>dL', function()
        local sessions = dap.sessions()
        if vim.tbl_isempty(sessions) then
          vim.notify('No active debug sessions', vim.log.levels.WARN)
          return
        end

        local items = {}
        for session_id, session in pairs(sessions) do
          local config = session.config
          table.insert(items, {
            text = string.format('[%d] %s', session_id, config.name or 'Unnamed'),
            session_id = session_id,
          })
        end

        vim.ui.select(items, {
          prompt = 'Select debug session:',
          format_item = function(item)
            return item.text
          end,
        }, function(choice)
          if choice then
            dap.set_session(dap.sessions()[choice.session_id])
            vim.notify('Switched to session: ' .. choice.text, vim.log.levels.INFO)
          end
        end)
      end, { desc = 'list and switch debug sessions' })

      -- Show active debug sessions count
      vim.keymap.set('n', '<leader>dI', function()
        local sessions = dap.sessions()
        local count = 0
        local names = {}
        for _, session in pairs(sessions) do
          count = count + 1
          table.insert(names, session.config.name or 'Unnamed')
        end

        if count == 0 then
          vim.notify('No active debug sessions', vim.log.levels.INFO)
        else
          vim.notify(
            string.format('%d active session(s):\n- %s', count, table.concat(names, '\n- ')),
            vim.log.levels.INFO
          )
        end
      end, { desc = 'show debug session info' })

      local function get_build_info()
        local handle = io.popen("date '+%F %T'")
        local build_time = handle:read('*a'):gsub('\n', ''):gsub(' ', '\\ ') -- Escape spaces
        handle:close()

        handle = io.popen('git rev-parse HEAD')
        local commit_sha1 = handle:read('*a'):gsub('\n', '')
        handle:close()

        return build_time, commit_sha1
      end

      local BUILD_TIME, COMMIT_SHA1 = get_build_info()

      dap_go.setup({
        dap_configurations = {
          {
            type = 'go',
            name = 'Debug (KubeRay operator)',
            request = 'launch',
            program = './main.go',
            args = {
              '-leader-election-namespace',
              'default',
              '-use-kubernetes-proxy',
            },
            cwd = '${workspaceFolder}/ray-operator',
            dlvCwd = '${workspaceFolder}/ray-operator',
          },
          {
            -- 	go run -race cmd/main.go -localSwaggerPath ${REPO_ROOT}/proto/swagger
            -- 	NOTE: run from apiserver/
            type = 'go',
            name = 'Debug (KubeRay apiserver)',
            request = 'launch',
            program = vim.fn.getcwd() .. '/' .. 'cmd/main.go',
            args = {
              '-localSwaggerPath',
              vim.fn.getcwd() .. '/proto/swagger',
            },
            cwd = vim.fn.getcwd(),
          },
          {
            type = 'go',
            name = 'Debug (Flyte default config)',
            request = 'launch',
            program = vim.fn.getcwd() .. '/' .. 'cmd',
            args = {
              'start',
              '--config',
              vim.fn.getcwd() .. '/' .. 'flyte-single-binary-local.yaml',
            },
            env = {
              POD_NAMESPACE = 'flyte',
            },
            buildFlags = '-tags console -v',
            cwd = vim.fn.getcwd(),
          },
          {
            type = 'go',
            name = 'Debug (Cloud Devbox)',
            request = 'launch',
            program = vim.fn.getcwd() .. '/' .. 'devbox/main.go',
            args = {
              'start',
              '--config',
              vim.fn.getcwd() .. '/' .. 'devbox/local.yaml',
            },
            env = {
              AWS_ENDPOINT_URL = 'http://localhost:4566',
            },
            cwd = vim.fn.getcwd(),
          },
          -- {
          --     type = "go",
          --     name = "Debug (Flyte Spark config)",
          --     request = "launch",
          --     program = vim.fn.getcwd() .. "/" .. "cmd",
          --     args = {
          --         "start",
          --         "--config",
          --         vim.fn.getcwd() .. "/" .. "../spark-values-override.yaml",
          --     },
          --     env = {
          --         POD_NAMESPACE = "flyte",
          --     },
          --     buildFlags = "-tags console -v",
          --     cwd = vim.fn.getcwd(),
          -- },
          -- {
          --     type = "go",
          --     name = "Debug (update workflow-execution-config)",
          --     request = "launch",
          --     mode = "debug",                      -- Use `debug` mode to run `go run` with debugging
          --     program = vim.fn.getcwd() .. "/" .. "main.go",
          --     args = {
          --         "update",
          --         "workflow-execution-config",
          --         "--attrFile",
          --         "../build/wec.yaml",
          --     },
          --     cwd = vim.fn.getcwd(), -- Use the current working directory
          --     buildFlags = "", -- Add build flags if needed
          -- },
          -- {
          --     type = "go",
          --     name = "Debug (Flytectl input args)",
          --     request = "launch",
          --     mode = "debug",                      -- Use `debug` mode to run `go run` with debugging
          --     program = vim.fn.getcwd() .. "/" .. "main.go",
          --     args = function()
          --         local args_input = vim.fn.input("Enter arguments (separated by spaces): ")
          --         local args = {}
          --         for arg in string.gmatch(args_input, "%S+") do
          --             table.insert(args, arg)
          --         end
          --         return args
          --     end,
          --     cwd = vim.fn.getcwd(), -- Use the current working directory
          --     buildFlags = "", -- Add build flags if needed
          -- },
          -- {
          --     type = "go",
          --     name = "Debug (Flytectl)",
          --     request = "launch",
          --     program = vim.fs.joinpath(vim.fn.getcwd(), "main.go"),
          --     args = {
          --         "demo",
          --         "start",
          --         "--disable-agent",
          --         "--force",
          --     },
          --     -- env = {},
          --     -- buildFlags = "-tags console -v",
          --     cwd = vim.fn.getcwd(),
          -- },
          {
            name = 'Debug Test Current File',
            type = 'go',
            request = 'launch',
            mode = 'test',
            -- cwd = "${fileDirname}", -- The directory of the current file
            program = '${fileDirname}', -- Test the entire package where the file resides
            -- program = "${file}", -- Current file with the test
            showLog = true,
            outputMode = 'remote',
            args = { '-test.v' },
            -- cwd = vim.fn.getcwd(),
            -- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
            dlvCwd = '${fileDirname}',
          },
          {
            type = 'go',
            name = 'Debug Test Current File Specific Go Test',
            request = 'launch',
            mode = 'test',
            -- program = "${file}", -- Current file with the test
            program = '${fileDirname}', -- Test the entire package where the file resides
            showLog = true,
            outputMode = 'remote',
            -- dlvCwd = vim.fs.joinpath(vim.fn.getcwd(), "${fileDirname}"),
            dlvCwd = '${fileDirname}',
            -- args = { "-test.run", "^TestFunctionName$" }, -- Replace TestFunctionName dynamically
            -- cwd = "./${relativeFileDirname}",
            args = function()
              -- Get the test name under the cursor
              -- local test_name = get_current_function_name()
              local test_name = vim.fn.expand('<cword>')
              return { '-test.run', '^' .. test_name .. '$', '-test.v' }
            end,
          },
          {
            type = 'delve',
            name = 'Debug',
            request = 'launch',
            program = function()
              return vim.fs.root(0, { { 'go.mod' }, '.git' }) or '${file}'
            end,
          },
          {
            type = 'delve',
            name = 'Attach',
            mode = 'local',
            request = 'attach',
            processId = function()
              return require('dap.utils').pick_process()
            end,
          },
          {
            type = 'delve',
            name = 'Debug test',
            request = 'launch',
            mode = 'test',
            program = '${file}',
          },
          {
            type = 'delve',
            name = 'Debug test (go.mod)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
          },
          {
            type = 'go',
            name = 'Delve: debug test (manually enter test name)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
            args = function()
              local testname = vim.fn.input('Test name (^regexp$ ok): ')
              return { '-test.run', testname }
            end,
          },
          {
            type = 'go',
            name = 'Debug (Main) Package',
            request = 'launch',
            program = 'main.go',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'go',
            name = "Delve: debug opened file's cmd/cli",
            request = 'launch',
            cwd = '${fileDirname}', -- FIXME: should work from repo root
            program = './${relativeFileDirname}',
            args = {},
          },
        },
      })

      -- Override dap-go's adapter to bypass Go version check
      -- (dap-go.setup overwrites dap.adapters.go, so we set it after setup)
      dap.adapters.go = {
        type = 'server',
        port = '${port}',
        executable = {
          command = 'dlv',
          args = { 'dap', '-l', '127.0.0.1:${port}', '--check-go-version=false' },
          detached = vim.fn.has('win32') == 0,
        },
      }
      --
      -- vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#993939', bg = '#31353f' })
      -- vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef', bg = '#31353f' })
      -- vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bg = '#31353f' })
      --
      -- vim.api.nvim_set_hl(0, 'DapBreakpointLine', { ctermbg = 0, bg = '#31353f' })
      -- vim.api.nvim_set_hl(0, 'DapLogPointLine', { ctermbg = 0, bg = '#31353f' })
      -- vim.api.nvim_set_hl(0, 'DapStoppedLine', { ctermbg = 0, bg = '#31353f' })
      --
      -- vim.fn.sign_define(
      --   'DapBreakpoint',
      --   { text = '🔴', texthl = 'DapBreakpoint', linehl = 'DapBreakpointLine', numhl = 'DapBreakpoint' }
      -- )
      -- vim.fn.sign_define(
      --   'DapBreakpointCondition',
      --   { text = '⭕', texthl = 'DapBreakpoint', linehl = 'DapBreakpointLine', numhl = 'DapBreakpoint' }
      -- )
      -- vim.fn.sign_define(
      --   'DapBreakpointRejected',
      --   { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpointLine', numhl = 'DapBreakpoint' }
      -- )
      -- vim.fn.sign_define(
      --   'DapLogPoint',
      --   { text = '', texthl = 'DapLogPoint', linehl = 'DapLogPointLine', numhl = 'DapLogPoint' }
      -- )
      -- vim.fn.sign_define(
      --   'DapStopped',
      --   { text = '', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = 'DapStopped' }
      -- )
    end,
  },
}
