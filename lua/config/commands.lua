-- json
vim.api.nvim_create_user_command("JsonDemangle", "%!jq '.'", { force = true })
