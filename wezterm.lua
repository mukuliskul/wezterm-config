local wezterm = require("wezterm")

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Load appearance, tabs, keybindings from config_modules directory
for _, modname in ipairs({ "appearance", "tab_bar", "key_bindings" }) do
	local opts = require("config_modules." .. modname)
	for k, v in pairs(opts) do
		config[k] = v
	end
end

-- Set up plugins
require("config_modules.plugins")(config)

-- Load custom events (these register event handlers globally)
require("config_modules.events")

return config
