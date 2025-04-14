local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local conf = require('telescope.config').values
local action_state = require('telescope.actions.state')
local actions = require('telescope.actions')
local previewers = require('telescope.previewers')

local M = {}

-- Custom previewer with line wrapping
M.prompt_previewer = previewers.new_buffer_previewer({
  title = 'System Prompt Preview',
  define_preview = function(self, entry, status)
    local preview = entry.preview
    if type(preview) == 'string' then
      -- Split the preview into lines
      local lines = vim.split(preview, '\n')

      -- Clean up empty lines at start and end
      while lines[1] and lines[1]:match('^%s*$') do
        table.remove(lines, 1)
      end
      while lines[#lines] and lines[#lines]:match('^%s*$') do
        table.remove(lines)
      end

      -- Set buffer options for better rendering
      vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'markdown')
      vim.api.nvim_win_set_option(self.state.winid, 'wrap', true)
      vim.api.nvim_win_set_option(self.state.winid, 'linebreak', true)

      -- Insert the lines
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    end
  end,
})

function M.browse(modes)
  local available_modes = modes.get_modes()

  -- Sort modes to put built-in modes at the top
  table.sort(available_modes, function(a, b)
    local a_builtin = modes.modes[a.name] ~= nil
    local b_builtin = modes.modes[b.name] ~= nil
    if a_builtin ~= b_builtin then
      return a_builtin
    end
    return a.name < b.name
  end)

  -- Add user icon to built-in modes and * for current mode
  local current_mode = vim.g.cc_mode or 'default'
  for _, mode in ipairs(available_modes) do
    local display = mode.name:gsub('^%l', string.upper)
    if modes.modes[mode.name] then
      display = '  ' .. display
    end
    if mode.name == current_mode then
      display = display .. ' *'
    end
    mode.display = display
  end

  pickers
    .new({}, {
      prompt_title = 'Select Chat Mode',
      finder = finders.new_table({
        results = available_modes,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.name,
            preview = entry.prompt,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = M.prompt_previewer,
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            modes.switch_mode(selection.ordinal)
          end
        end)
        return true
      end,
    })
    :find()
end

return M
