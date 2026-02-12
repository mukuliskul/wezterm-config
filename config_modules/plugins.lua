-- plugins.lua
local wezterm = require("wezterm")

return function(config)
	local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
	workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"
	-- Key binding is now in key_bindings.lua
end
