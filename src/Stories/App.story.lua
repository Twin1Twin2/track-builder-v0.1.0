--- [Story]: App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)

local Components = root.Components

local App = require(Components.App)

local function Component()
	return Roact.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		Component = Roact.createElement(App, {}),
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