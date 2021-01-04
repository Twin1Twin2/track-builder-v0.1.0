--- RectSegment

local Segment = require(script.Parent.Segment)

local segmentUtil = script.Parent.Util
local Draw3DRect = require(segmentUtil.Draw3DRect)
local DEFAULT_WEDGE = require(segmentUtil.DEFAULT_WEDGE)

local util = script.Parent.Parent.Util
local t = require(util.t)
local Vector3OffsetInstance = require(util.Vector3OffsetInstance)
local ObjectValueUtil = require(util.ObjectValueUtil)


local DEFAULT_NAME = "Rect"

local RectSegment = {
	ClassName = "RectSegment";
}

RectSegment.__index = RectSegment
setmetatable(RectSegment, Segment)


function RectSegment.new()
	local self = setmetatable(Segment.new(), RectSegment)

	self.Name = DEFAULT_NAME

	self.Wedge = DEFAULT_WEDGE:Clone()

	self.P0 = Vector3.new()
	self.P1 = Vector3.new()
	self.P2 = Vector3.new()
	self.P3 = Vector3.new()


	return self
end


local IsData = t.interface({
	Name = t.optional(t.string),

	Wedge = t.optional(t.instanceOf("WedgePart")),

	P0 = t.Vector3,
	P1 = t.Vector3,
	P2 = t.Vector3,
	P3 = t.Vector3,
})


function RectSegment.fromData(data)
	assert(IsData(data))

	local self = RectSegment.new()

	self.Name = data.Name or DEFAULT_NAME

	self.Wedge = data.Wedge or DEFAULT_WEDGE:Clone()

	self.P0 = data.P0
	self.P1 = data.P1
	self.P2 = data.P2
	self.P3 = data.P3


	return self
end


RectSegment.IsInstanceData = t.children({
	Wedge = t.optional(
		ObjectValueUtil.Type(t.instanceOf("WedgePart"))
	),

	P0 = Vector3OffsetInstance.IsInstanceData,
	P1 = Vector3OffsetInstance.IsInstanceData,
	P2 = Vector3OffsetInstance.IsInstanceData,
	P3 = Vector3OffsetInstance.IsInstanceData,
})

local GetVector3OffsetFromInstance = Vector3OffsetInstance.Get

function RectSegment.fromInstance(instance)
	assert(RectSegment.IsInstanceData(instance))

	local wedge = instance:FindFirstChild("Wedge")
	if wedge then
		wedge = ObjectValueUtil.Reduce(wedge)
		wedge = wedge:Clone()
	end

	local p0Value = instance:FindFirstChild("P0")
	local p1Value = instance:FindFirstChild("P1")
	local p2Value = instance:FindFirstChild("P2")
	local p3Value = instance:FindFirstChild("P3")

	return RectSegment.fromData({
		Name = instance.Name,

		Wedge = wedge,

		P0 = GetVector3OffsetFromInstance(p0Value),
		P1 = GetVector3OffsetFromInstance(p1Value),
		P2 = GetVector3OffsetFromInstance(p2Value),
		P3 = GetVector3OffsetFromInstance(p3Value),
	})
end


local checkCreate = t.tuple(
	t.CFrame
)

function RectSegment:Create(cframe, _)
	assert(checkCreate(cframe))

	local wedge = self.Wedge

	local p0 = self.P0
	local p1 = self.P1
	local p2 = self.P2
	local p3 = self.P3

	local model = Instance.new("Model")
	model.Name = self.Name

	Draw3DRect(
		cframe:PointToWorldSpace(p0),
		cframe:PointToWorldSpace(p1),
		cframe:PointToWorldSpace(p2),
		cframe:PointToWorldSpace(p3),
		wedge,
		model
	)

	return model
end


return RectSegment