--- [Story]: App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local Components = root.Components

local TextWithTitle = require(Components.TextWithTitle)

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
			TextWithTitle = Roact.createElement(TextWithTitle, {
				Size = UDim2.fromOffset(280, 48),
				Title = "TextWithTitle:",
				Text = "Something Goes Here"
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