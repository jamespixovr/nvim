vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.lsp.foldexpr()'

-- vim.opt_local.conceallevel = 2

-- local optl = vim.opt_local

--------------------------------------------------------------------------------

-- optl.expandtab = false
-- optl.tabstop = 4 -- less nesting in md, so we can afford larger tabstop
-- vim.bo.commentstring = '<!-- %s -->' -- add spaces
--
-- -- so two trailing spaces highlighted, but not a single trailing space
-- optl.listchars:remove('trail')
-- optl.listchars:append({ multispace = '·' })
--
-- -- since markdown has rarely indented lines, and also rarely has overlong lines,
-- -- move everything a bit more to the right
-- if vim.bo.buftype == '' then
--   optl.signcolumn = 'yes:4'
-- end

--------------------------------------------------------------------------------
