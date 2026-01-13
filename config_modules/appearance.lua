local wezterm = require("wezterm")

-- Function to determine color scheme based on system appearance
local function get_color_scheme()
	local appearance = wezterm.gui and wezterm.gui.get_appearance() or "Dark"

	if appearance:find("Dark") then
		return "kanagawabones" -- Your preferred dark theme
	else
		return "One Light (Gogh)" -- Soft, balanced light theme from Atom One
	end
end

return {
	color_scheme = get_color_scheme(),
	font = wezterm.font_with_fallback({
		"Source Code Pro",
		"JetBrains Mono",
		"Fira Code",
	}),
	font_size = 14,
	window_decorations = "RESIZE",
	-- Performance optimizations
	front_end = "WebGpu",
	max_fps = 60,
	webgpu_present_mode = "Mailbox",
	freetype_load_target = "Normal",
}
