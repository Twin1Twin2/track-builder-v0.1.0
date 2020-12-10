--- BoxRailSegment
-- Creates a box made of wedges parallel to the track

local Segment = require(script.Parent.Segment)

local segmentUtil = script.Parent.Util
local Draw3DRect = require(segmentUtil.Draw3DRect)
local DEFAULT_WEDGE = require(segmentUtil.DEFAULT_WEDGE)

local util = script.Parent.Parent.Util
local t = require(util.t)

local DEFAULT_NAME = "BoxRail"

local BoxRailSegment = {
	ClassName = "BoxRailSegment";
}

BoxRailSegment.__index = BoxRailSegment
setmetatable(BoxRailSegment, Segment)


function BoxRailSegment.new()
	local self = setmetatable(Segment.new(), BoxRailSegment)

	self.Name = DEFAULT_NAME

	self.Wedge = DEFAULT_WEDGE:Clone()

	self.TopLeft = Vector3.new()
	self.TopRight = Vector3.new()
	self.BottomLeft = Vector3.new()
	self.BottomRight = Vector3.new()

	self.DrawTop = true
	self.DrawBottom = true
	self.DrawLeft = true
	self.DrawRight = true


	return self
end

local IsData = t.interface({
	Name = t.optional(t.string),

	Wedge = t.optional(t.instanceOf("WedgePart")),

	TopLeft = t.Vector3,
	TopRight = t.Vector3,
	BottomLeft = t.Vector3,
	BottomRight = t.Vector3,

	DrawTop = t.optional(t.boolean),
	DrawBottom = t.optional(t.boolean),
	DrawLeft = t.optional(t.boolean),
	DrawRight = t.optional(t.boolean),
})

local function GetOr(value, default)
	if value ~= nil then
		return value
	end

	return default
end

function BoxRailSegment.fromData(data)
	assert(IsData(data))

	local drawTop = GetOr(data.DrawTop, true)
	local drawBottom = GetOr(data.DrawBottom, true)
	local drawLeft = GetOr(data.DrawLeft, true)
	local drawRight = GetOr(data.DrawRight, true)

	local self = BoxRailSegment.new()

	self.Name = data.Name or DEFAULT_NAME

	self.Wedge = data.Wedge or DEFAULT_WEDGE:Clone()

	self.TopLeft = data.TopLeft
	self.TopRight = data.TopRight
	self.BottomLeft = data.BottomLeft
	self.BottomRight = data.BottomRight

	self.DrawTop = drawTop
	self.DrawBottom = drawBottom
	self.DrawLeft = drawLeft
	self.DrawRight = drawRight


	return self
end


local IsInstance = t.children({
	Wedge = t.optional(t.instanceOf("WedgePart")),

	TopLeft = t.instanceOf("Vector3Value"),
	TopRight = t.instanceOf("Vector3Value"),
	BottomLeft = t.instanceOf("Vector3Value"),
	BottomRight = t.instanceOf("Vector3Value"),

	DrawTop = t.optional(t.instanceOf("BoolValue")),
	DrawBottom = t.optional(t.instanceOf("BoolValue")),
	DrawLeft = t.optional(t.instanceOf("BoolValue")),
	DrawRight = t.optional(t.instanceOf("BoolValue")),
})

function BoxRailSegment.fromInstance(instance)
	assert(IsInstance(instance))

	local wedge = instance:FindFirstChild("Wedge")

	local topLeftValue = instance:FindFirstChild("TopLeft")
	local topRightValue = instance:FindFirstChild("TopRight")
	local bottomLeftValue = instance:FindFirstChild("BottomLeft")
	local bottomRightValue = instance:FindFirstChild("BottomRight")

	local function GetBoolValueOr(valueName, default)
		local value = instance:FindFirstChild(valueName)
		if value then
			return value.Value
		end

		return default
	end

	local drawTop = GetBoolValueOr("DrawTop", true)
	local drawBottom = GetBoolValueOr("DrawBottom", true)
	local drawLeft = GetBoolValueOr("DrawLeft", true)
	local drawRight = GetBoolValueOr("DrawRight", true)

	return BoxRailSegment.fromData({
		Name = instance.Name,

		Wedge = wedge,

		TopLeft = topLeftValue.Value,
		TopRight = topRightValue.Value,
		BottomLeft = bottomLeftValue.Value,
		BottomRight = bottomRightValue.Value,

		DrawTop = drawTop,
		DrawBottom = drawBottom,
		DrawLeft = drawLeft,
		DrawRight = drawRight,
	})
end


local checkCreate = t.tuple(
	t.CFrame,
	t.CFrame
)

function BoxRailSegment:Create(startCFrame, endCFrame)
	assert(checkCreate(startCFrame, endCFrame))

	local wedge = self.Wedge

	local topLeft = self.TopLeft
	local topRight = self.TopRight
	local bottomLeft = self.BottomLeft
	local bottomRight = self.BottomRight

	local model = Instance.new("Model")
	model.Name = self.Name

	local function DrawQuadBetweenPoints(offset1, offset2)
		Draw3DRect(
			startCFrame:PointToWorldSpace(offset1),
			startCFrame:PointToWorldSpace(offset2),
			endCFrame:PointToWorldSpace(offset1),
			endCFrame:PointToWorldSpace(offset2),
			wedge,
			model
		)
	end

	if self.DrawTop then
		DrawQuadBetweenPoints(
			topLeft,
			topRight
		)
	end

	if self.DrawBottom then
		DrawQuadBetweenPoints(
			bottomLeft,
			bottomRight
		)
	end

	if self.DrawLeft then
		DrawQuadBetweenPoints(
			topLeft,
			bottomLeft
		)
	end

	if self.DrawRight then
		DrawQuadBetweenPoints(
			topRight,
			bottomRight
		)
	end

	return model
end


return BoxRailSegment