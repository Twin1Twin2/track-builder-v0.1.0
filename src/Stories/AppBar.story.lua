--- [Story]: App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local Components = root.Components

local AppBar = require(Components.AppBar)

local function Component()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Dark,
	}, {
		Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			Component = Roact.createElement(AppBar, {
				--
			}),
		})
	})
end

return function(target)
	local handle = Roact.mount(
		Roact.createElement(Component),
		target
	)

    return function()
        Roact.unmount(handle)
    end
end