-- https://github.com/kazhala/close-buffers.nvim
local pair_ok, closebuffer = pcall(require, 'close_buffers')
if not pair_ok then
  return
end

local u = require('modules.utils.utils')

closebuffer.setup({
  filetype_ignore = {},  -- Filetype to ignore when running deletions
  file_glob_ignore = {},  -- File name glob pattern to ignore when running deletions (e.g. '*.md')
  file_regex_ignore = {}, -- File name regex pattern to ignore when running deletions (e.g. '.*[.]md')
  preserve_window_layout = { 'this', 'nameless' },  -- Types of deletion that should preserve the window layout
  next_buffer_cmd = nil,  -- Custom function to retrieve the next buffer when preserving window layout
})

u.nmap('<Leader>q', [[<CMD>lua require('close_buffers').delete({type = 'this'})<CR>]])

