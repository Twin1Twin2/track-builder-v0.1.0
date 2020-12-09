--- App

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactRodux = require(modules.RoactRodux)
local RoactMaterial = require(modules.RoactMaterial)

local components = root.Components
local StudioThemeAccessor = require(components.StudioThemeAccessor)
local AppBar = require(components.AppBar)
local TextWithTitle = require(components.TextWithTitle)
local TextField = require(components.TextField)

local PluginManager = require(root.PluginManager)


local App = Roact.PureComponent:extend("App")

function App:init()

end

function App:render()
	local props = self.props

	return StudioThemeAccessor.withTheme(function(studioTheme, themeType)
		local currentTheme = self.props.themeType or themeType
		local theme

		if currentTheme == Enum.UITheme.Light then
			theme = RoactMaterial.Themes.Light
		else
			theme = RoactMaterial.Themes.Dark
		end

		return Roact.createElement(RoactMaterial.ThemeProvider, {
			Theme = theme,
		}, {
			Frame = Roact.createElement("Frame", {
				Size = UDim2.fromScale(1, 1),
				-- BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundColor3 = studioTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground),
				BorderSizePixel = 0,
			}, {
				AppBar = Roact.createElement(AppBar, {
					Position = UDim2.fromOffset(0, 0),
					ZIndex = 100,
				}),
				AppMenu = Roact.createElement("Frame", {
					Size = UDim2.new(1, 0, 1, -56),
					Position = UDim2.new(0, 0, 0, 56),
					BackgroundTransparency = 1,
					ZIndex = 1,
				}, {
					UIPadding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 8),
						PaddingBottom = UDim.new(0, 8),
						PaddingLeft = UDim.new(0, 8),
						PaddingRight = UDim.new(0, 8),
					}),
					UIListLayout = Roact.createElement("UIListLayout", {
						Padding = UDim.new(0, 8),
						FillDirection = Enum.FillDirection.Vertical,
						SortOrder = Enum.SortOrder.LayoutOrder,
					}),
					CurrentTrack = Roact.createElement(TextWithTitle, {
						Class = "Button",
						Size = UDim2.new(1, 0, 0, 48),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Title = "Track:",
						Text = props.currentTrack or "[NOTHING]",
						LayoutOrder = 1,
					}),
					TrackPositions = Roact.createElement("Frame", {
						Size = UDim2.new(1, 0, 0, 48),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						LayoutOrder = 2,
					}, {
						UIListLayout = Roact.createElement("UIListLayout", {
							Padding = UDim.new(0, 8),
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
						}),
						StartTextField = Roact.createElement(TextField, {
							Size = UDim2.new(0.5, -4, 1, 0),
							LayoutOrder = 1,

							Title = "Start:",
							Text = tostring(props.startPosition),

							validateNumber = true,
							enterPressed = function(value)
								PluginManager:SetStartPosition(value)
							end,
						}),
						EndTextField = Roact.createElement(TextField, {
							Size = UDim2.new(0.5, -4, 1, 0),
							LayoutOrder = 2,

							Title = "End:",
							Text = tostring(props.endPosition),

							validateNumber = true,
							enterPressed = function(value)
								PluginManager:SetEndPosition(value)
							end,
						})
					}),
					CurrentTrackGroup = Roact.createElement(TextWithTitle, {
						Class = "Button",
						Size = UDim2.new(1, 0, 0, 48),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Title = "Track Group:",
						Text = props.currentTrackGroup or "[NOTHING]",
						LayoutOrder = 3,
					}),
				})
			})
		})
	end)
end

local function mapStateToProps(state, _)
    return {
        currentTrack = state.currentTrack,
        currentTrackGroup = state.currentTrackGroup,

		startPosition = state.startPosition,
        endPosition = state.endPosition,
    }
end

local function mapDispatchToProps(_)
    return {

    }
end

App = RoactRodux.connect(
    mapStateToProps,
    mapDispatchToProps
)(App)


return App