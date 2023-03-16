local projectnvim_ok, projectnvim = pcall(require, "project_nvim")
if not projectnvim_ok then
	return
end

projectnvim.setup({})
