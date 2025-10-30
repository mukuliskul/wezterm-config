local wezterm = require("wezterm")
local module = {}

-- The directory that contains all your projects. Modify this path as required.
local project_dir = wezterm.home_dir .. "/mpac-commercial/projects"

function module.choose_project()
	return wezterm.action_callback(function(window, pane)
		local projects = { wezterm.home_dir }
		for _, dir in ipairs(wezterm.glob(project_dir .. "/*")) do
			table.insert(projects, dir)
		end
		local choices = {}
		for _, value in ipairs(projects) do
			table.insert(choices, { label = value })
		end
		window:perform_action(
			wezterm.action.InputSelector({
				title = "Projects",
				choices = choices,
				fuzzy = true,
				action = wezterm.action_callback(function(child_window, child_pane, id, label)
					if not label then
						return
					end
					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = label:match("([^/]+)$"),
							spawn = { cwd = label },
						}),
						child_pane
					)
				end),
			}),
			pane
		)
	end)
end

return module
