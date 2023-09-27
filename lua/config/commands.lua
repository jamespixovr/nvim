-- json
vim.api.nvim_create_user_command("JsonDemangle", "%!jq '.'", { force = true })

-- delete blank lines
vim.api.nvim_create_user_command("DeleteBlankLines", function()
  local input = vim.fn.input("", ":g/^$/d")
  vim.cmd(input)
  vim.fn.histadd("cmd", input)
end, { force = true })
-- count word
vim.api.nvim_create_user_command("CountWord", function()
  local current_word = vim.fn.expand("<cword>")
  local input = vim.fn.input("", [[%s/\<]] .. current_word .. [[\>/&/gn]])
  vim.cmd(input)
  vim.fn.histadd("cmd", input)
end, { force = true })
vim.api.nvim_create_user_command("SelectedInfo", "normal! gvg<C-g>", { force = true, range = "%" })

-- open definition in preview window
vim.api.nvim_create_user_command("PreviewDefinition", "normal! <C-w>}", { force = true })

-- Spell Dictionary
vim.api.nvim_create_user_command("AddCorrectSpell", "normal! zg", { force = true })
vim.api.nvim_create_user_command("AddWrongSpell", "normal! zw", { force = true })
vim.api.nvim_create_user_command("ChangeCorrectSpell", "normal! z=", { force = true })
vim.api.nvim_create_user_command("FixCorrectSpell", "ChangeCorrectSpell", { force = true })
vim.api.nvim_create_user_command("CorrectSpell", "ChangeCorrectSpell", { force = true })
