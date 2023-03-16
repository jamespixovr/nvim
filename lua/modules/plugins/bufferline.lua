local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

local u = require('modules.utils.utils')

bufferline.setup {
  options = {
    numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
    show_close_icon = false,
    diagnostics = "nvim_lsp",
    always_show_bufferline = true,
    separator_style = "thin",
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or "")
        s = s .. sym .. n
      end
      return s
    end,
    offsets = {
      {
        filetype = "NvimTree",
        text = "",
        highlight = "Directory",
        text_align = "left",
        padding = 1
      },
    },
  },
}

for i = 1, 9 do
  i = tostring(i)
  u.nmap("<leader>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
end
