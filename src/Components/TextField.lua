--- Implementation of Material's Text Field as RoactMaterial2 doesn't have one
-- actions:
-- click on it:
--	- Focused on TextBox
--
--	- Enter Pressed
---	- Filter Text

local root = script.Parent.Parent

local modules = root.Modules
local Roact = require(modules.Roact)
local RoactMaterial = require(modules.RoactMaterial)

local components = root.Components
local StudioThemeAccessor = require(components.StudioThemeAccessor)

local util = root.Util
local t = require(util.t)

local TextField = Roact.Component:extend("TextField")
TextField.validateProps = t.interface({
	enterPressed = t.callback,
	-- setText = t.callback,
})

function TextField:init()
    self.state = {
        focused = false,
        currentValue = nil,
    }
    -- self.onTextChanged = function(rbx)
	-- 	if rbx.Text ~= self.props.Text then
	-- 		self.props.setText(rbx.Text)
	-- 	end
	-- end
    self._textBoxRef = Roact.createRef()
end


function TextField:render()
	local props = self.props

	return StudioThemeAccessor.withTheme(function(_, themeEnum)
		return Roact.createElement("Frame",{
			BackgroundTransparency = 0.95,
			BackgroundColor3 = themeEnum == Enum.UITheme.Dark
				and Color3.new(1, 1, 1)
				or Color3.new(0, 0, 0),
			BorderSizePixel = 0,
			Size = props.Size,
			Position = props.Position,
			AnchorPoint = self.props.AnchorPoint,
			LayoutOrder = self.props.LayoutOrder,
		}, {
			Title = Roact.createElement(RoactMaterial.TextView, {
				Class = "Caption",

				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 16, 0, 0),
				Size = UDim2.new(1, 0, 0, 16),

				Text = props.Title or "",
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			TextBox = Roact.createElement("TextBox", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),

				ClearTextOnFocus = props.ClearTextOnFocus,
				PlaceholderText = props.PlaceholderText,

				Text = props.Text or "",
				TextColor3 = themeEnum == Enum.UITheme.Dark
					and Color3.new(1, 1, 1)
					or Color3.new(0, 0, 0),

				Font = Enum.Font.SourceSans,
				TextSize = 18,

				[Roact.Ref] = self._textBoxRef,
				[Roact.Event.Focused] = function()
					self:setState({
						focused = true,
					})
				end,
				[Roact.Event.FocusLost] = function(enterPressed, input)
					local textBox = self._textBoxRef:getValue()

					if enterPressed then
						local text = textBox.Text
						if props.validateNumber then
							text = tonumber(text)
							if text then
								props.enterPressed(text, input)
							else
								textBox.Text = props.Text
							end
						else
							props.enterPressed(text, input)
						end
					end

					self:setState({
						focused = false,
					})
				end,
				-- [Roact.Change.Text] = function(rbx)
				-- 	-- workaround because we do not disconnect events before we start unmounting host components.
				-- 	-- see https://github.com/Roblox/roact/issues/235 for more info
				-- 	if not self._textBoxRef:getValue() then return end

				-- 	-- self.onTextChanged(rbx)
				-- end
			}),
			Line = Roact.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 0),
				Size = UDim2.new(1, -20, 0, 1),
				Position = UDim2.new(0.5, 0, 1, -6),
				BackgroundColor3 = themeEnum == Enum.UITheme.Dark
					and (props.Disabled and Color3.fromRGB(150, 150, 150)
						or Color3.fromRGB(203, 203, 203))
					or (props.Disabled and Color3.fromRGB(105, 105, 105)
						or Color3.fromRGB(0, 0, 0)),

				BorderSizePixel = 0,

				Visible = not self.state.focused,
			})
		})
	end)
end


return TextField