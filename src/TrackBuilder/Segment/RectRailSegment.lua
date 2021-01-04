--- RectRailSegment

local Segment = require(script.Parent.Segment)

local segmentUtil = script.Parent.Util
local Draw3DRect = require(segmentUtil.Draw3DRect)
local DEFAULT_WEDGE = require(segmentUtil.DEFAULT_WEDGE)

local util = script.Parent.Parent.Util
local t = require(util.t)
local Vector3OffsetInstance = require(util.Vector3OffsetInstance)
local ObjectValueUtil = require(util.ObjectValueUtil)


local DEFAULT_NAME = "RectRail"

local RectRailSegment = {
	ClassName = "RectRailSegment";
}

RectRailSegment.__index = RectRailSegment
setmetatable(RectRailSegment, Segment)


function RectRailSegment.new()
	local self = setmetatable(Segment.new(), RectRailSegment)

	self.Name = DEFAULT_NAME

	self.Wedge = DEFAULT_WEDGE:Clone()

	self.StartOffset1 = Vector3.new()
	self.StartOffset2 = Vector3.new()

	self.EndOffset1 = Vector3.new()
	self.EndOffset2 = Vector3.new()


	return self
end

local IsData = t.interface({
	Name = t.optional(t.string),

	Wedge = t.optional(t.instanceOf("WedgePart")),

	StartOffset1 = t.Vector3,
	StartOffset2 = t.Vector3,
	EndOffset1 = t.Vector3,
	EndOffset2 = t.Vector3,

	UseStart = t.optional(t.boolean),
})


function RectRailSegment.fromData(data)
	assert(IsData(data))

	local startOffset1 = data.StartOffset1
	local startOffset2 = data.StartOffset2

	local endOffset1 = data.EndOffset1
	local endOffset2 = data.EndOffset2

	if data.UseStart == true then
		endOffset1 = startOffset1
		endOffset2 = startOffset2
	end

	local self = RectRailSegment.new()

	self.Name = data.Name or DEFAULT_NAME

	self.Wedge = data.Wedge or DEFAULT_WEDGE:Clone()

	self.StartOffset1 = startOffset1
	self.StartOffset2 = startOffset2

	self.EndOffset1 = endOffset1
	self.EndOffset2 = endOffset2

	return self
end


RectRailSegment.IsInstanceData = t.children({
	Wedge = t.optional(
		ObjectValueUtil.Type(t.instanceOf("WedgePart"))
	),

	StartOffset1 = Vector3OffsetInstance.IsInstanceData,
	StartOffset2 = Vector3OffsetInstance.IsInstanceData,
	EndOffset1 = Vector3OffsetInstance.IsInstanceData,
	EndOffset2 = Vector3OffsetInstance.IsInstanceData,
})

local GetVector3OffsetFromInstance = Vector3OffsetInstance.Get

function RectRailSegment.fromInstance(instance)
	assert(RectRailSegment.IsInstanceData(instance))

	local wedge = instance:FindFirstChild("Wedge")
	if wedge then
		wedge = ObjectValueUtil.Reduce(wedge)
		wedge = wedge:Clone()
	end

	local startOffset1Value = instance:FindFirstChild("StartOffset1")
	local startOffset2Value = instance:FindFirstChild("StartOffset2")
	local endOffset1Value = instance:FindFirstChild("EndOffset1")
	local endOffset2Value = instance:FindFirstChild("EndOffset2")

	return RectRailSegment.fromData({
		Name = instance.Name,

		Wedge = wedge,

		StartOffset1 = GetVector3OffsetFromInstance(startOffset1Value),
		StartOffset2 = GetVector3OffsetFromInstance(startOffset2Value),
		EndOffset1 = GetVector3OffsetFromInstance(endOffset1Value),
		EndOffset2 = GetVector3OffsetFromInstance(endOffset2Value),
	})
end



local checkCreate = t.tuple(
	t.CFrame,
	t.CFrame
)

local function GetOffsetPosition(cframe, offset)
	return (cframe * CFrame.new(offset)).Position
end

function RectRailSegment:Create(startCFrame, endCFrame)
	assert(checkCreate(startCFrame, endCFrame))

	local wedge = self.Wedge

	local startPosition1 = GetOffsetPosition(startCFrame, self.StartOffset1)
	local startPosition2 = GetOffsetPosition(startCFrame, self.StartOffset2)
	local endPosition1 = GetOffsetPosition(endCFrame, self.EndOffset1)
	local endPosition2 = GetOffsetPosition(endCFrame, self.EndOffset2)

	local model = Instance.new("Model")

	Draw3DRect(
		startPosition1,
		startPosition2,
		endPosition1,
		endPosition2,
		wedge,
		model
	)

	return model
end


return RectRailSegment