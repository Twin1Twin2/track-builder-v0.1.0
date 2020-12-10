--- MidTrackObjectSegment

local Segment = require(script.Parent.Segment)

local segmentUtil = script.Parent.Util
local NewSmooth = require(segmentUtil.NewSmooth)

local util = script.Parent.Parent.Util
local t = require(util.t)
local IsModelWithPrimaryPart = require(util.IsModelWithPrimaryPart)

local DEFAULT_NAME = "MidTrackObject"

local MidTrackObjectSegment = {
	ClassName = "MidTrackObjectSegment";
}

MidTrackObjectSegment.__index = MidTrackObjectSegment
setmetatable(MidTrackObjectSegment, Segment)


function MidTrackObjectSegment.new()
	local self = setmetatable(Segment.new(), MidTrackObjectSegment)

	self.Name = DEFAULT_NAME

	self.Object = nil
	self.Offset = CFrame.new()

	self.UseLookVector = false


	return self
end

local IsData = t.interface({
	Name = t.optional(t.string),

	Object = t.union(
		t.instanceIsA("BasePart"),
		IsModelWithPrimaryPart
	),
	Offset = t.CFrame,
	UseLookVector = t.boolean,
})

function MidTrackObjectSegment.fromData(data)
	assert(IsData(data))

	local self = MidTrackObjectSegment.new()

	self.Name = data.Name or DEFAULT_NAME
	self.Object = data.Object
	self.Offset = data.Offset
	self.UseLookVector = data.UseLookVector


	return self
end


local IsInstance = t.children({
	Object = t.union(
		t.instanceIsA("BasePart"),
		IsModelWithPrimaryPart
	),
	Offset = t.optional(t.instanceOf("CFrameValue")),
	UseLookVector = t.optional(t.instanceOf("BoolValue"))
})

function MidTrackObjectSegment.fromInstance(instance)
	assert(IsInstance(instance))

	local object = instance:FindFirstChild("Object")
	local offsetValue = instance:FindFirstChild("Offset")
	local useLookVectorValue = instance:FindFirstChild("UseLookVector")

	local offset = CFrame.new()
	if offsetValue then
		offset = offsetValue.Value
	end

	local useLookVector = false
	if useLookVectorValue then
		useLookVector = useLookVectorValue.Value
	end

	return MidTrackObjectSegment.fromData({
		Name = instance.Name,

		Object = object,
		Offset = offset,

		UseLookVector = useLookVector,
	})
end


local function GetLookVectorCFrame(cframe)
    local p = cframe.Position
    local lv = cframe.LookVector

    return CFrame.new(p, p + lv)
end

local checkCreate = t.tuple(
	t.CFrame,
	t.CFrame
)

function MidTrackObjectSegment:Create(startCFrame, endCFrame)
	assert(checkCreate(startCFrame, endCFrame))

	local cframe, _, _	-- kinda a hack. not optimized
		= NewSmooth(
			startCFrame,
			self.Offset,
			endCFrame,
			self.Offset,
			Vector3.new(1, 1, 1),
			Vector3.new(0, 0, 0),
			false,
			nil
		)

	local object = self.Object:Clone()
	local offset = self.Offset

	if self.UseLookVector == true then
		cframe = GetLookVectorCFrame(cframe)
	end

	local newCFrame = cframe:ToWorldSpace(offset)

	if object:IsA("Model") then
		object:SetPrimaryPartCFrame(newCFrame)
	else	-- assume part
		object.CFrame = newCFrame
	end

	return object
end


return MidTrackObjectSegment