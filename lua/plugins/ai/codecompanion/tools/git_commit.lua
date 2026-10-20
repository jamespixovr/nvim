---@class CodeCompanion.Tool.GitCommit: CodeCompanion.Tools.Tool
return {
  name = 'git_commit',
  description = 'Commit the staged changes with the given commit message',
  cmds = {
    ---@param self CodeCompanion.Tools
    ---@param args table
    ---@param opts { output_cb: fun(result: table), register_job: fun(job: vim.SystemObj) }
    function(_, args, opts)
      if not args.message or args.message == '' then
        return { status = 'error', data = 'No commit message was provided' }
      end

      local output_cb = vim.schedule_wrap(opts.output_cb)

      local job = vim.system({ 'git', 'commit', '-m', args.message }, { text = true }, function(out)
        if out.code ~= 0 then
          return output_cb({ status = 'error', data = out.stderr ~= '' and out.stderr or out.stdout })
        end

        output_cb({ status = 'success', data = out.stdout })
      end)

      opts.register_job(job)
    end,
  },
  schema = {
    type = 'function',
    ['function'] = {
      name = 'git_commit',
      description = 'Commit the staged changes with the given commit message',
      parameters = {
        type = 'object',
        properties = {
          message = {
            type = 'string',
            description = 'The full commit message, including any ticket prefix',
          },
        },
        required = { 'message' },
        additionalProperties = false,
      },
      strict = true,
    },
  },
  output = {
    ---@param self CodeCompanion.Tool.GitCommit
    ---@return string
    cmd_string = function(self)
      return 'git commit -m ' .. vim.fn.shellescape(self.args.message)
    end,

    ---@param self CodeCompanion.Tool.GitCommit
    ---@return string
    prompt = function(self)
      return 'Commit the staged changes with the message `' .. self.args.message .. '`?'
    end,

    ---@param self CodeCompanion.Tool.GitCommit
    ---@param stdout table
    ---@param meta { tools: CodeCompanion.Tools }
    success = function(self, stdout, meta)
      local output = stdout and stdout[#stdout] or 'git commit succeeded'
      meta.tools.chat:add_tool_output(self, {
        content = 'Committed the staged changes:\n' .. output,
        display = output,
      })
    end,

    ---@param self CodeCompanion.Tool.GitCommit
    ---@param stderr table
    ---@param meta { tools: CodeCompanion.Tools }
    error = function(self, stderr, meta)
      local output = stderr and stderr[#stderr] or 'git commit failed'
      meta.tools.chat:add_tool_output(self, {
        content = 'git commit failed:\n' .. output,
        display = output,
      })
    end,
  },
}
