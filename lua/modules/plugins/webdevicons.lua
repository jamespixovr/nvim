
local webdevicon_ok, webdevicon = pcall(require, "nvim-web-devicons")
if not webdevicon_ok then
  return
end

webdevicon.setup {
  default = true
}
