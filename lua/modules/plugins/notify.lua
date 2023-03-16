local status_ok, notify = pcall(require, "notify")
if not status_ok then
	return
end

local icons = require("modules.utils.icons")
local notify_renderers = require("notify.render")

notify.setup({
	-- Animation style (see below for details)
	stages = "fade_in_slide_out",

	-- Function called when a new window is opened, use for changing win settings/config
	on_open = nil,

	-- Function called when a window is closed
	on_close = nil,

	-- Render function for notifications. See notify-render()
	render = function(bufnr, notif, ...)
		if notif.title[1] == "" then
			return notify_renderers.minimal(bufnr, notif, ...)
		else
			return notify_renderers.default(bufnr, notif, ...)
		end
	end,

	-- Default timeout for notifications
	timeout = 2000, -- 2.0 seconds

	-- For stages that change opacity this is treated as the highlight behind the window
	-- Set this to either a highlight group or an RGB hex value e.g. "#000000"
	background_colour = "#000000",

	max_width = function()
		return math.ceil(math.max(vim.opt.columns:get() / 3, 10))
	end,
	max_height = function()
		return math.ceil(math.max(vim.opt.lines:get() / 3, 4))
	end,

	-- Icons for the different levels
	icons = {
		ERROR = icons.diagnostics.Error,
		WARN = icons.diagnostics.Warning,
		INFO = icons.diagnostics.Information,
		DEBUG = icons.ui.Bug,
		TRACE = icons.ui.Pencil,
	},
})

vim.notify = notify
