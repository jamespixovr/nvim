-- https://github.com/lazymaniac/nvim-ide/blob/master/lua/plugins/ai.lua
local last_action = ''
-- Helper class definition

-- Code Editor helper
local CodeEditor = {}
CodeEditor.__index = CodeEditor

function CodeEditor:new()
  local instance = setmetatable({}, CodeEditor)
  return instance
end

CodeEditor.deltas = {}

function CodeEditor:add_delta(bufnr, line, delta)
  table.insert(self.deltas, { bufnr = bufnr, line = line, delta = delta })
end

function CodeEditor:open_buffer(filename)
  if not filename or filename == '' then
    vim.notify('No filename provided to open_buffer', vim.log.levels.ERROR)
    return nil
  end

  if vim.fn.filereadable(filename) == 0 then
    vim.notify('File is unreadable. Path: ' .. filename, vim.log.levels.WARN)
  end

  local bufnr = vim.fn.bufadd(filename)
  vim.fn.bufload(bufnr)
  vim.api.nvim_set_current_buf(bufnr)

  return bufnr
end

function CodeEditor:get_bufnr_by_filename(filename)
  for _, bn in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(bn) == filename then
      return bn
    end
  end
  return self:open_buffer(filename)
end

function CodeEditor:intersect(bufnr, line)
  local delta = 0
  for _, v in ipairs(self.deltas) do
    if bufnr == v.bufnr and line > v.line then
      delta = delta + v.delta
    end
  end
  return delta
end

function CodeEditor:delete(action)
  local start_line
  local end_line
  start_line = tonumber(action.start_line)
  assert(start_line, 'No start line number provided by the LLM')
  if start_line == 0 then
    start_line = 1
  end

  end_line = tonumber(action.end_line)
  assert(end_line, 'No end line number provided by the LLM')
  if end_line == 0 then
    end_line = 1
  end

  local bufnr = self:get_bufnr_by_filename(action.filename)

  if bufnr then
    local delta = self:intersect(bufnr, start_line)

    vim.api.nvim_buf_set_lines(bufnr, start_line + delta - 1, end_line + delta, false, {})
    self:add_delta(bufnr, start_line, (start_line - end_line - 1))
  else
    vim.notify("Can't find buffer number by file name.", vim.log.levels.ERROR)
  end
end

function CodeEditor:add(action)
  local start_line
  start_line = tonumber(action.start_line)
  assert(start_line, 'No line number provided by the LLM')
  if start_line == 0 then
    start_line = 1
  end

  local bufnr = self:get_bufnr_by_filename(action.filename)

  if bufnr then
    local delta = self:intersect(bufnr, start_line)

    local lines = vim.split(action.code, '\n', { plain = true, trimempty = false })
    vim.api.nvim_buf_set_lines(bufnr, start_line + delta - 1, start_line + delta - 1, false, lines)

    self:add_delta(bufnr, start_line, tonumber(#lines))
  else
    vim.notify("Can't find buffer number by file name", vim.log.levels.WARN)
  end
end

-- Code Extractor helper
local CodeExtractor = {}
CodeExtractor.__index = CodeExtractor

function CodeExtractor:new()
  local instance = setmetatable({}, CodeExtractor)
  return instance
end

CodeExtractor.lsp_timeout_ms = 10000
CodeExtractor.symbol_data = {}
CodeExtractor.filetype = ''

CodeExtractor.lsp_methods = {
  get_definition = vim.lsp.protocol.Methods.textDocument_definition,
  get_references = vim.lsp.protocol.Methods.textDocument_references,
  get_implementation = vim.lsp.protocol.Methods.textDocument_implementation,
}

CodeExtractor.DEFINITION_NODE_TYPES = {
  -- Functions and Classes
  function_definition = true,
  method_definition = true,
  class_definition = true,
  function_declaration = true,
  method_declaration = true,
  constructor_declaration = true,
  class_declaration = true,
  -- Variables and Constants
  variable_declaration = true,
  const_declaration = true,
  let_declaration = true,
  field_declaration = true,
  property_declaration = true,
  const_item = true,
  -- Language-specific definitions
  struct_item = true,
  function_item = true,
  impl_item = true,
  enum_item = true,
  type_item = true,
  attribute_item = true,
  trait_item = true,
  static_item = true,
  interface_declaration = true,
  type_declaration = true,
  decorated_definition = true,
}

function CodeExtractor:is_valid_buffer(bufnr)
  return bufnr and vim.api.nvim_buf_is_valid(bufnr)
end

function CodeExtractor:get_buffer_lines(bufnr, start_row, end_row)
  if not self:is_valid_buffer(bufnr) then
    vim.notify('Provided bufnr is invalid: ' .. bufnr, vim.log.levels.WARN)
    return nil
  end
  return vim.api.nvim_buf_get_lines(bufnr, start_row, end_row, false)
end

function CodeExtractor:get_node_data(bufnr, node)
  if not (node and bufnr) then
    return nil
  end

  local start_row, start_col, end_row, end_col = node:range()
  local lines = self:get_buffer_lines(bufnr, start_row, end_row + 1)

  if not lines then
    vim.notify('Symbol text range is empty.', vim.log.levels.WARN)
    return nil
  end

  local code_block
  if start_row == end_row then
    code_block = lines[1]:sub(start_col + 1, end_col)
  else
    lines[1] = lines[1]:sub(start_col + 1)
    lines[#lines] = lines[#lines]:sub(1, end_col)
    code_block = table.concat(lines, '\n')
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)

  return {
    code_block = code_block,
    start_line = start_row + 1,
    end_line = end_row + 1,
    filename = filename,
  }
end

function CodeExtractor:get_symbol_data(bufnr, row, col)
  if not self:is_valid_buffer(bufnr) then
    vim.notify('Invalid buffer id:' .. bufnr)
    return nil
  end

  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then
    vim.notify("Can't initialize tree-sitter parser for buffer id: " .. bufnr, vim.log.levels.ERROR)
    return nil
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  local node = root:named_descendant_for_range(row, col, row, col)

  while node do
    if self.DEFINITION_NODE_TYPES[node:type()] then
      return self:get_node_data(bufnr, node)
    end
    node = node:parent()
  end

  return nil
end

function CodeExtractor:validate_lsp_params(bufnr, method)
  if not (bufnr and method) then
    vim.notify(
      'Unable to call lsp. Missing bufnr or method. buffer=' .. bufnr .. ' method=' .. method,
      vim.log.levels.WARN
    )
    return false
  end
  return true
end

function CodeExtractor:execute_lsp_request(bufnr, method)
  local position_params = vim.lsp.util.make_position_params(0, vim.lsp.client.offset_encoding)

  local results_by_client, err = vim.lsp.buf_request_sync(bufnr, method, position_params, self.lsp_timeout_ms)
  if err then
    vim.notify('LSP error: ' .. tostring(err), vim.log.levels.ERROR)
    return nil
  end
  return results_by_client
end

function CodeExtractor:process_single_range(uri, range)
  if not (uri and range) then
    return
  end

  local target_bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(target_bufnr)

  local data = self:get_symbol_data(target_bufnr, range.start.line, range.start.character)
  if data then
    table.insert(self.symbol_data, data)
  else
    vim.notify("Can't extract symbol data.", vim.log.levels.WARN)
  end
end

function CodeExtractor:process_lsp_result(result)
  if result.range then
    self:process_single_range(result.uri or result.targetUri, result.range)
    return
  end

  if #result > 10 then
    vim.notify('Too many results for symbol. Ignoring', vim.log.levels.WARN)
    return
  end

  for _, item in pairs(result) do
    self:process_single_range(item.uri or item.targetUri, item.range or item.targetSelectionRange)
  end
end

function CodeExtractor:call_lsp_method(bufnr, method)
  if not self:validate_lsp_params(bufnr, method) then
    return
  end

  local results_by_client = self:execute_lsp_request(bufnr, method)
  if not results_by_client then
    return
  end

  for _, lsp_results in pairs(results_by_client) do
    self:process_lsp_result(lsp_results.result or {})
  end
end

function CodeExtractor:move_cursor_to_symbol(symbol)
  local bufs = vim.api.nvim_list_bufs()

  for _, bufnr in ipairs(bufs) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_get_option_value('modifiable', { buf = bufnr }) then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

      for i, line in ipairs(lines) do
        local col = line:find(symbol)

        if col then
          local win_ids = vim.fn.win_findbuf(bufnr)
          if #win_ids > 0 then
            vim.api.nvim_set_current_win(win_ids[1])
            vim.api.nvim_win_set_cursor(0, { i, col - 1 })
            return bufnr
          end
          break
        end
      end
    end
  end
  return -1
end

-- Helpers initioalization
local code_extractor = CodeExtractor:new()
local code_editor = CodeEditor:new()

return {
  description = 'Act as developer by utilizing LSP methods and code modification capabilities.',
  opts = {
    user_approval = false,
  },
  callback = {
    name = 'code_developer',
    cmds = {
      function(_, action, _)
        local type = action._attr.type
        last_action = type
        local symbol = action.symbol

        if type == 'edit' then
          code_editor:delete(action)
          code_editor:add(action)
          return { status = 'success', msg = nil }
        else
          local bufnr = code_extractor:move_cursor_to_symbol(symbol)

          if code_extractor.lsp_methods[type] then
            code_extractor:call_lsp_method(bufnr, code_extractor.lsp_methods[type])
            code_extractor.filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
            return { status = 'success', msg = nil }
          else
            vim.notify('Unsupported LSP method', vim.log.levels.WARN)
          end
        end

        return { status = 'error', msg = 'No symbol found' }
      end,
    },
    schema = {
      {
        tool = {
          _attr = { name = 'code_developer' },
          action = {
            _attr = { type = 'get_definition' },
            symbol = '<![CDATA[UserRepository]]>',
          },
        },
      },
      {
        tool = {
          _attr = { name = 'code_developer' },
          action = {
            _attr = { type = 'get_references' },
            symbol = '<![CDATA[saveUser]]>',
          },
        },
      },
      {
        tool = {
          _attr = { name = 'code_developer' },
          action = {
            _attr = { type = 'get_implementation' },
            symbol = '<![CDATA[Comparable]]>',
          },
        },
      },
      {
        tool = {
          _attr = { name = 'code_developer' },
          action = {
            _attr = { type = 'edit' },
            filename = '/nvim/lua/plugins/ai.lua',
            start_line = 21,
            end_line = 31,
            code = '<![CDATA[function hello_world() end]]',
          },
        },
      },
      {
        tool = {
          _attr = { name = 'code_developer' },
          action = {
            {
              _attr = { type = 'get_definition' },
              symbol = '<![CDATA[UserService]]>',
            },
            {
              _attr = { type = 'get_definition' },
              symbol = '<![CDATA[refreshUser]]>',
            },
            {
              _attr = { type = 'get_references' },
              symbol = '<![CDATA[UserService]]>',
            },
          },
        },
      },
    },
    system_prompt = function(schema)
      return string.format(
        [[## Code Developer Tool (`code_developer`) Guidelines

## MANDATORY USAGE
Use `get_definition`, `get_references` or `get_implementation` AT THE START of EVERY coding task to gather context before answering. Don't overuse these actions. Think what is needed to solve the task, don't fall into rabbit hole.
Use `edit` action only when asked by user.

## Purpose
Traverses the codebase to find definitions, references, or implementations of code symbols to provide error proof solution
OR
Replace old code with new implementation

## Execution Format
Return XML in this format:

a) **Get Definition Action:** Find where symbol is defined
```xml
%s
```

b) **Get References Action:** Find all usages of symbol
```xml
%s
```

c) **Get Implementation Action:** Find implementations of interfaces/abstract classes
```xml
%s
```

d) **Multiple Actions**: Combine actions in one response if needed

```xml
%s
```

d) **Edit Action**: Replace fragment of code. Use only on user request.

```xml
%s
```

## Important
- Always wrap symbols in CDATA sections
- Wait for tool results before providing solutions
- Minimize explanations about the tool itself
- When looking for symbol, pass only the name of symbol without the object. So use: `saveUsers` as symbol instead of `userRepository.saveUsers`
]],
        require('codecompanion.utils.xml.xml2lua').toXml({ tools = { schema[1] } }), -- Get Definition
        require('codecompanion.utils.xml.xml2lua').toXml({ tools = { schema[2] } }), -- Get References
        require('codecompanion.utils.xml.xml2lua').toXml({ tools = { schema[3] } }), -- Get Implementation
        require('codecompanion.utils.xml.xml2lua').toXml({ tools = { schema[5] } }), -- Multiple actions
        require('codecompanion.utils.xml.xml2lua').toXml({ tools = { schema[4] } }) -- Edit code
      )
    end,
    handlers = {
      on_exit = function(agent)
        code_extractor.symbol_data = {}
        code_extractor.filetype = ''
        if last_action ~= 'edit' then
          vim.notify('Symbols submitted to LLM')
          return agent.chat:submit()
        end
      end,
    },
    output = {
      success = function(self, action, _)
        local type = action._attr.type
        local symbol = action.symbol
        local buf_message_content = ''

        for _, code_block in ipairs(code_extractor.symbol_data) do
          buf_message_content = buf_message_content
            .. string.format(
              [[
---
The %s of symbol: `%s`
Filename: %s
Start line: %s
End line: %s
Content:
```%s
%s
```
---
]],
              string.upper(type),
              symbol,
              code_block.filename,
              code_block.start_line,
              code_block.end_line,
              code_extractor.filetype,
              code_block.code_block
            )
        end

        return self.chat:add_buf_message({
          role = require('codecompanion.config').constants.USER_ROLE,
          content = buf_message_content,
        })
      end,
      error = function(self, action, err)
        return self.chat:add_buf_message({
          role = require('codecompanion.config').constants.USER_ROLE,
          content = string.format(
            [[There was an error running the %s action:

```txt
%s
```]],
            string.upper(action._attr.type),
            err
          ),
        })
      end,
      rejected = function(self, action)
        return self.chat:add_buf_message({
          role = require('codecompanion.config').constants.USER_ROLE,
          content = string.format('I rejected the %s action.\n\n', string.upper(action._attr.type)),
        })
      end,
    },
  },
}
