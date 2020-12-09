--- [Story]: App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local Components = root.Components

local TextField = require(Components.TextField)

local function Component()
	return Roact.createElement(RoactMaterial.ThemeProvider, {
		Theme = RoactMaterial.Themes.Light,
	}, {
		Frame = Roact.createElement("Frame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
		}, {
			TextField = Roact.createElement(TextField, {
				Size = UDim2.fromOffset(280, 48),
				ClearTextOnFocus = false,
				PlaceholderText = "PlaceholderText"
			}),
		}),
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