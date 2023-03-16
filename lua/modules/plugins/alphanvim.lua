local alpha_ok, alpha = pcall(require, "alpha")
if not alpha_ok then
	return
end

local startify = require("alpha.themes.startify")
-- ignore filetypes in MRU
---@diagnostic disable-next-line: unused-local
startify.mru_opts.ignore = function(path, ext)
	return (string.find(path, "COMMIT_EDITMSG"))
end
-- local dashboard = require("alpha.themes.dashboard").
alpha.setup(startify.config)
