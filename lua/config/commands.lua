-- json
vim.api.nvim_create_user_command('JsonDemangle', "%!jq '.'", { force = true })
vim.api.nvim_create_user_command('Uuid', 'read !uuidgen', { force = true })

-- vim.api.nvim_create_user_command("Uuid", function()
--   local uuid = vim.fn.system("uuidgen"):gsub("\n", ""):lower()
--   local line = vim.fn.getline(".")
--   vim.schedule(function()
--     vim.fn.setline(".", vim.fn.strpart(line, 0, vim.fn.col(".")) .. uuid .. vim.fn.strpart(line, vim.fn.col(".")))
--   end)
-- end, { force = true })
