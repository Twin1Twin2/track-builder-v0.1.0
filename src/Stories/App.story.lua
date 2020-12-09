--- [Story]: App

local root = script.Parent.Parent
local Reducer = require(root.Reducer)
local PluginManager = require(root.PluginManager)

local modules = root.Modules
local Roact = require(modules.Roact)
local Rodux = require(modules.Rodux)
local RoactRodux = require(modules.RoactRodux)

local Components = root.Components
local App = require(Components.App)

Roact.setGlobalConfig({
	-- propValidation = true,
	-- elementTracing = true,
})

return function(target)
    local store = Rodux.Store.new(Reducer)
	PluginManager:InitStore(store)

    local app = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		Frame = Roact.createElement("Frame", {
			Size = UDim2.new(0, 360, 1, 0),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
		}, {
			App = Roact.createElement(App, {
				themeType = Enum.UITheme.Dark
			}),
		})
	})

	local handle = Roact.mount(
		app,
		target
	)

	return function()
		-- PluginManager:Clear()
        Roact.unmount(handle)
    end
end