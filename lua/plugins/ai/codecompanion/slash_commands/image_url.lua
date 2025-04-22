---@param chat CodeCompanion.Chat
local function slash_add_image_url(chat)
  local function callback(input)
    if input then
      local id = '<image_url>' .. input .. '</image_url>'
      local new_message = {
        {
          type = 'text',
          text = 'the user is sharing this image with you. be ready for a query or task regarding this image',
        },
        {
          type = 'image_url',
          image_url = {
            url = input, -- truncated
          },
        },
      }

      local constants = require('codecompanion.config').config.constants
      chat:add_message({
        role = constants.USER_ROLE,
        content = vim.fn.json_encode(new_message),
      }, { reference = id, visible = false })

      chat.references:add({
        id = id,
        source = 'adapter.image_url',
      })
    end
  end
  vim.ui.input({ prompt = '> Enter image url', default = '', completion = 'dir' }, callback)
end

return {
  description = 'add image via url',
  callback = slash_add_image_url,
  opts = {
    contains_code = false,
  },
}
