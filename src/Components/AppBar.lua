
local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local PluginActions = require(root.PluginActions)
local ProgramActions = PluginActions.ProgramActions

local PluginManager = require(root.PluginManager)


local AppBar = Roact.Component:extend("AppBar")

local OPTIONS = {
	"Run Program",
	"Print Track Positions",
	"Load Track",
	"Load Section"
}

local function OptionSelected(option)
	if option == OPTIONS[1] then
		ProgramActions.RunSelectedPrograms()
	elseif option == OPTIONS[2] then
		PluginActions.PrintTrackPositions()
	elseif option == OPTIONS[3] then
		PluginManager:LoadSelectedTrack()
	elseif option == OPTIONS[4] then
		PluginManager:LoadSelectedTrackGroup()
	else
		warn("Invalid Option Chosen! Idk how this happened")
	end
end


function AppBar:init()
	self.state = {
		open = false,
	}
end


function AppBar:render()
	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundTransparency = 1,
		ZIndex = self.props.ZIndex,
		AnchorPoint = self.props.AnchorPoint,
		Position = self.props.Position,
	}, {
		Shadow = Roact.createElement(RoactMaterial.Shadow, {
			Elevation = 4,
			ZIndex = 1,
		}),
		Frame = Roact.createElement("Frame", {
			BackgroundColor3 = RoactMaterial.Themes.Light.PrimaryColor,
			BorderSizePixel = 0,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 2,
		}, {
			PrimaryButton = Roact.createElement(RoactMaterial.TransparentButton, {
				Size = UDim2.fromOffset(40, 40),
				Position = UDim2.new(0, 8, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),

				OnClicked = function()
					self:setState({
						open = not self.state.open,
					})
				end
			}, {
				Icon = Roact.createElement(RoactMaterial.Icon, {
					Icon = "menu",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(24, 24),
					IconColor3 = Color3.new(),
				}),
				Menu = Roact.createElement(RoactMaterial.Menu, {
					Position = UDim2.fromScale(0, 1),
					Width = UDim.new(0, 200),
					Open = self.state.open,
					Options = OPTIONS,

					ZIndex = 100,
					OnOptionSelected = function(option)
						OptionSelected(option)
						self:setState({
							open = false,
						})
					end,
				}),
			}),
			AppTitle = Roact.createElement(RoactMaterial.TextView, {
				Class = "Title",

				Position = UDim2.new(0, 72, 0.5, 0),
				Size = UDim2.new(1, -72, 1, 0),
				AnchorPoint = Vector2.new(0, 0.5),

				Text = "Track Builder",
				TextXAlignment = Enum.TextXAlignment.Left,

			}),
			BuildButton = Roact.createElement(RoactMaterial.TransparentButton, {
				Size = UDim2.fromOffset(40, 40),
				Position = UDim2.new(1, -36, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),

				OnClicked = function()
					PluginManager:Build()
				end
			}, {
				Icon = Roact.createElement(RoactMaterial.Icon, {
					Icon = "build",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(24, 24),
					IconColor3 = Color3.new(),
				}),
			}),

			MoreVertical = Roact.createElement(RoactMaterial.TransparentButton, {
				Size = UDim2.fromOffset(20, 40),
				Position = UDim2.new(1, -8, 0.5, 0),
				AnchorPoint = Vector2.new(1, 0.5),

				OnClicked = function()
					print("Options!")
				end
			}, {
				Icon = Roact.createElement(RoactMaterial.Icon, {
					Icon = "more_vert",
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Size = UDim2.fromOffset(24, 24),
					IconColor3 = Color3.new(),
				}),
			}),
		})
	})
end


return AppBar