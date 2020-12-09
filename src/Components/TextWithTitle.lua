--- TextWithTitle
-- Temp

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local function TextWithTitle(props)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		Size = props.Size,
		Position = props.Position,
	}, {
		Title = Roact.createElement(RoactMaterial.TextView, {
			Class = "Caption",

			AnchorPoint = Vector2.new(0, 0),
			Position = UDim2.new(0, 16, 0, 0),
			Size = UDim2.new(1, 0, 0, 16),

			Text = props.Title or "",
			TextXAlignment = Enum.TextXAlignment.Left,
		}),
		Text = Roact.createElement(RoactMaterial.TextView, {
			Class = "Button",

			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),

			Text = props.Text or "",
		})
	})
end


return TextWithTitle