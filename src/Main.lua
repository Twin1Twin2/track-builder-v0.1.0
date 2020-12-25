--- Main
-- Taken from Hoarcekat (which was taken from Roblox Tag Editor, I didn't need the load previous state atm)
--

local PLUGIN_NAME = "Track Builder"

local root = script.Parent
local modules = root.Modules

local Roact = require(modules.Roact)
local RoactRodux = require(modules.RoactRodux)
local Rodux = require(modules.Rodux)

local Reducer = require(script.Parent.Reducer)
local Config = require(script.Parent.Config)

local App = require(script.Parent.Components.App)

local PluginManager = require(script.Parent.PluginManager)

local function getPrefix(plugin)
	if plugin.isDev then
		return " [DEV]", "Dev"
	elseif Config.betaRelease then
		return " [BETA]", "Beta"
	end

	return "", ""
end

local function getIcon(plugin)
	if plugin.isDev then
		return "http://www.roblox.com/asset/?id=5374547990"
	else
		return "http://www.roblox.com/asset/?id=5374547990"
	end
end

local function Main(plugin, savedState)
	local displayPrefix, namePrefix = getPrefix(plugin)
	local toolbar = plugin:toolbar(displayPrefix .. PLUGIN_NAME)

	local pluginIcon = getIcon(plugin)

	local toggleButton = plugin:button(
		toolbar,
		PLUGIN_NAME,
		("Open the %s window"):format(
			PLUGIN_NAME
		),
		pluginIcon
	)

	local store = Rodux.Store.new(Reducer, savedState)
	PluginManager:InitStore(store)

	local info = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, false, false, 0, 0)

	local gui = plugin:createDockWidgetPluginGui(namePrefix .. PLUGIN_NAME, info)
	gui.Name = namePrefix .. PLUGIN_NAME
	gui.Title = displayPrefix .. PLUGIN_NAME
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	toggleButton:SetActive(gui.Enabled)

	local connection = toggleButton.Click:Connect(function()
		gui.Enabled = not gui.Enabled
		toggleButton:SetActive(gui.Enabled)
	end)

	local app = Roact.createElement(RoactRodux.StoreProvider, {
		store = store,
	}, {
		App = Roact.createElement(App),
	})

	local instance = Roact.mount(app, gui, PLUGIN_NAME)

	plugin:beforeUnload(function()
		Roact.unmount(instance)
		connection:Disconnect()

		PluginManager:Destroy()

		return store:getState()
	end)

	local unloadConnection
	unloadConnection = gui.AncestryChanged:Connect(function()
		print(("New %s version coming online; Unloading the old version..."):format(
			PLUGIN_NAME
		))
		unloadConnection:Disconnect()
		plugin:unload()
	end)
end

return Main