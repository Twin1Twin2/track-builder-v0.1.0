--- App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local components = root.Components
local StudioThemeAccessor = require(components.StudioThemeAccessor)

local PluginActions = require(root.PluginActions)


local App = Roact.PureComponent:extend("App")

function App:init()

end

function App:render()
	return StudioThemeAccessor.withTheme(function(studioTheme, themeType)
		local theme
		if themeType == Enum.UITheme.Light then
			theme = RoactMaterial.Themes.Light
		else
			theme = RoactMaterial.Themes.Dark
		end

		return Roact.createElement(RoactMaterial.ThemeProvider, {
			Theme = theme,
		}, {
			Frame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
				BorderSizePixel = 0,
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingBottom = UDim.new(0, 16),
					PaddingLeft = UDim.new(0, 16),
					PaddingRight = UDim.new(0, 16),
					PaddingTop = UDim.new(0, 16),
				}),
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8),
				}),
				RunProgramButton = Roact.createElement(RoactMaterial.Button, {
					Text = "RUN PROGRAM",
					Size = UDim2.new(1, 0, 0, 40),
					LayoutOrder = 1,
					OnClicked = function()
						PluginActions.RunPrograms()
					end,
				}),
				PrintTrackPositions = Roact.createElement(RoactMaterial.Button, {
					Text = "PRINT TRACK POSITIONS",
					Size = UDim2.new(1, 0, 0, 40),
					LayoutOrder = 2,
					OnClicked = function()
						PluginActions.PrintTrackPositions()
					end,
				}),
			})
		})
	end)
end

return App