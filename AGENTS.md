# WezTerm Configuration - Agent Guidelines

This document provides guidelines for AI coding agents working with this WezTerm configuration repository.

## Project Overview

This is a WezTerm terminal emulator configuration written in Lua. The configuration is modular, with separate files for different concerns:
- `wezterm.lua` - Main entry point
- `config_modules/` - Modular configuration components
  - `appearance.lua` - Color schemes and fonts
  - `key_bindings.lua` - Keyboard shortcuts
  - `tab_bar.lua` - Tab bar styling
  - `events.lua` - Event handlers
  - `plugins.lua` - Plugin management

## Testing & Validation

### Manual Testing
Since this is a configuration file project, testing is primarily manual:

```bash
# Test configuration by reloading WezTerm
# In WezTerm, press: Ctrl+Shift+R or use the command palette

# Check for syntax errors
lua wezterm.lua

# Validate configuration (if WezTerm CLI is available)
wezterm --config-file wezterm.lua
```

### Test Checklist
When making changes, verify:
1. Configuration loads without errors
2. Key bindings work as expected
3. Visual appearance renders properly
4. No performance regressions

## Code Style Guidelines

### Language & Runtime
- **Language**: Lua 5.1+ (WezTerm's embedded Lua runtime)
- **Primary API**: WezTerm Lua API (accessed via `require("wezterm")`)

### File Organization
- Place general configuration in `config_modules/`
- One concern per module (appearance, keybindings, events, etc.)
- Modules export either a table of config options or a function
- Main `wezterm.lua` imports and merges module configurations

### Lua Style Conventions

#### Indentation & Formatting
- Use **tabs** for indentation (not spaces)
- No trailing whitespace
- End files with a single newline
- Use blank lines to separate logical sections

#### Naming Conventions
- `snake_case` for variables, functions, and file names
- `UPPER_SNAKE_CASE` for constants
- Descriptive names (e.g., `get_project_dirs`, not `getWsDirs`)

#### Variables & Scope
- Prefer `local` variables to avoid polluting global scope
- Declare variables at narrowest possible scope
- Group related `local` declarations together

```lua
-- Good
local wezterm = require("wezterm")
local module = {}

-- Bad (global pollution)
wezterm = require("wezterm")
```

#### Functions
- Define module functions using dot notation: `function module.function_name()`
- Use descriptive parameter names
- Return early to reduce nesting

```lua
-- Good
function module.some_function()
	-- implementation
end
```

#### Tables
- Use trailing commas in multi-line table definitions
- Align similar items for readability
- Prefer explicit key-value pairs for clarity

```lua
-- Good
local config = {
	font_size = 14,
	max_fps = 60,
	window_decorations = "RESIZE",
}
```

#### Control Flow
- Use explicit comparisons for non-boolean values
- Prefer guard clauses over deep nesting
- Use `if not x then return end` for early returns

```lua
-- Good
if not id then
	return
end

-- Less ideal (deep nesting)
if id then
	-- lots of code
end
```

### Module Pattern
Modules should follow one of two patterns:

**Pattern 1: Config table export** (for static configuration)
```lua
return {
	hide_tab_bar_if_only_one_tab = false,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
}
```

**Pattern 2: Module table export** (for functions/dynamic config)
```lua
local module = {}

function module.some_function()
	-- implementation
end

return module
```

**Pattern 3: Factory function** (for plugins/configuration builders)
```lua
return function(config)
	-- modify config object
	-- register plugins, etc.
end
```

### WezTerm API Conventions

#### Require Pattern
Always start WezTerm modules with:
```lua
local wezterm = require("wezterm")
```

#### Action Callbacks
Use `wezterm.action_callback` for interactive actions:

#### Config Builder
Main config should use the config builder pattern:
```lua
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
```

### Performance Considerations
- Limit scrollback to reasonable values (10,000 lines)
- Use appropriate rendering backend (`WebGpu` for performance)
- Be mindful of event handler performance (they run frequently)

### Error Handling
- Check for nil values before use
- Use guard clauses for invalid states
- Provide sensible defaults when configuration is missing
- Fail gracefully (don't crash the terminal)

```lua
-- Good
local file = io.open(LAST_WORKSPACE_FILE, "r")
if file then
	local content = file:read("*all")
	file:close()
	return content:gsub("%s+", "")
end
return nil
```

## Common Tasks

### Adding a New Key Binding
1. Edit `config_modules/key_bindings.lua`
2. Add entry to the `keys` table
3. Test with Ctrl+Shift+R reload

### Adding a New Color Scheme
1. Edit `config_modules/appearance.lua`
2. Update `get_color_scheme()` function
3. Reload to see changes

### Creating a New Module
1. Create file in `config_modules/`
2. Export config table or module table
3. Import in `wezterm.lua` using appropriate pattern
4. Test configuration loading

## Git Workflow
- Commit messages should be descriptive
- Test configuration before committing
- Keep commits focused on single concerns
- No build artifacts to commit (pure config repo)

## Additional Notes
- WezTerm documentation: https://wezfurlong.org/wezterm/
- This config uses a leader key pattern (Ctrl+A, similar to tmux)
- Performance optimizations are in place (WebGpu, 60fps limit, 10k scrollback)
