local gps_ok, gps = pcall(require, "nvim-gps")
if not gps_ok then
	return
end

local icons = require("modules.utils.icons")
local space = " "

gps.setup({
	disable_icons = false, -- Setting it to true will disable all icons
	icons = {
		["class-name"] = "%#CmpItemKindClass#" .. icons.kind.Class .. "%*" .. space, -- Classes and class-like objects
		["function-name"] = "%#CmpItemKindFunction#" .. icons.kind.Function .. "%*" .. space, -- Functions
		["method-name"] = "%#CmpItemKindMethod#" .. icons.kind.Method .. "%*" .. space, -- Methods (functions inside class-like objects)
		["container-name"] = "%#CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space, -- Containers (example: lua tables)
		["tag-name"] = "%#CmpItemKindKeyword#" .. icons.misc.Tag .. "%*" .. " ", -- Tags (example: html tags)
		["mapping-name"] = "%#CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space,
		["sequence-name"] = "%CmpItemKindProperty#" .. icons.type.Array .. "%*" .. space,
		["null-name"] = "%CmpItemKindField#" .. icons.kind.Field .. "%*" .. space,
		["boolean-name"] = "%CmpItemKindValue#" .. icons.type.Boolean .. "%*" .. space,
		["integer-name"] = "%CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
		["float-name"] = "%CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
		["string-name"] = "%CmpItemKindValue#" .. icons.type.String .. "%*" .. space,
		["array-name"] = "%CmpItemKindProperty#" .. icons.type.Array .. "%*" .. space,
		["object-name"] = "%CmpItemKindProperty#" .. icons.type.Object .. "%*" .. space,
		["number-name"] = "%CmpItemKindValue#" .. icons.type.Number .. "%*" .. space,
		["table-name"] = "%CmpItemKindProperty#" .. icons.ui.Table .. "%*" .. space,
		["date-name"] = "%CmpItemKindValue#" .. icons.ui.Calendar .. "%*" .. space,
		["date-time-name"] = "%CmpItemKindValue#" .. icons.ui.Table .. "%*" .. space,
		["inline-table-name"] = "%CmpItemKindProperty#" .. icons.ui.Calendar .. "%*" .. space,
		["time-name"] = "%CmpItemKindValue#" .. icons.misc.Watch .. "%*" .. space,
		["module-name"] = "%CmpItemKindModule#" .. icons.kind.Module .. "%*" .. space,
	},
	separator = space .. icons.ui.ChevronRight .. space,
	-- limit for amount of context shown
	-- 0 means no limit
	-- Note: to make use of depth feature properly, make sure your separator isn't something that can appear
	-- in context names (eg: function names, class names, etc)
	depth = 0,

	-- indicator used when context is hits depth limit
	depth_limit_indicator = "..",
	text_hl = "LineNr",
})
