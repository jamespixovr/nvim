local files = require('overseer.files')
local log = require('overseer.log')
local parser = require('overseer.parser')
local problem_matcher = require('overseer.template.vscode.problem_matcher')
local user_util = require('overseer.component.user.util')

---@type overseer.ComponentFileDefinition
local comp = {
  desc = 'Parses task output and sets task result',
  params = {
    parser = {
      desc = 'Parser definition to extract values from output',
      type = 'opaque',
      optional = true,
      order = 1,
    },
    problem_matcher = {
      desc = 'VS Code-style problem matcher',
      type = 'opaque',
      optional = true,
      order = 2,
    },
    relative_file_root = {
      desc = 'Relative filepaths will be joined to this root (instead of task cwd)',
      optional = true,
      default_from_task = true,
      order = 3,
    },
    precalculated_vars = {
      desc = 'Precalculated VS Code task variables',
      long_desc = "Tasks that are started from the VS Code provider precalculate certain interpolated variables (e.g. ${workspaceFolder}). We pass those in as params so they will remain stable even if Neovim's state changes in between creating and running (or restarting) the task.",
      type = 'opaque',
      optional = true,
      order = 4,
    },
  },
  constructor = function(params)
    return {
      on_init = function(self, task)
        if params.parser and params.problem_matcher then
          log:warn("on_output_parse: cannot specify both 'parser' and 'problem_matcher'")
        end

        local parser_definition = params.parser

        -- Extract command in one line a display it in the notification
        ---@diagnostic disable-next-line: param-type-mismatch
        local command_line = type(task.cmd) == 'string' and task.cmd or table.concat(task.cmd, ' ') or ''

        local pm = user_util.get_problem_matcher(command_line, params)
        if pm then
          parser_definition = problem_matcher.get_parser_from_problem_matcher(pm, params.precalculated_vars)
          if parser_definition then
            parser_definition = { diagnostics = parser_definition }
          end
        end

        self.parser = parser.new(parser_definition or {})
        self.parser_sub = function(key, result)
          -- TODO reconsider this API for dispatching partial results
          -- task:dispatch("on_stream_result", key, result)
        end
        self.parser:subscribe('new_item', self.parser_sub)
        self.set_results_sub = function()
          local result = self.parser:get_result()
          if result.diagnostics then
            -- Ensure that all relative filenames are rooted at the task cwd, not vim's current cwd
            for _, diag in ipairs(result.diagnostics) do
              if diag.filename and not files.is_absolute(diag.filename) then
                diag.filename = files.join(params.relative_file_root or task.cwd, diag.filename)
              end
            end
          end
          task:set_result(result)
        end
        self.parser:subscribe('set_results', self.set_results_sub)
      end,
      on_dispose = function(self)
        if self.parser_sub then
          self.parser:unsubscribe('new_item', self.parser_sub)
          self.parser_sub = nil
        end
        if self.set_results_sub then
          self.parser:unsubscribe('set_results', self.set_results_sub)
          self.set_results_sub = nil
        end
      end,
      on_reset = function(self)
        if self.parser then
          self.parser:reset()
        end
      end,
      on_output_lines = function(self, task, lines)
        if self.parser then
          self.parser:ingest(lines)
        end
      end,
      on_pre_result = function(self, task)
        return self.parser and self.parser:get_result() or {}
      end,
    }
  end,
}

return comp
