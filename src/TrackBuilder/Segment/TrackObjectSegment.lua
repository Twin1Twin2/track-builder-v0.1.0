--- TrackObjectSegment

local Segment = require(script.Parent.Segment)

local util = script.Parent.Parent.Util
local t = require(util.t)
local IsModelWithPrimaryPart = require(util.IsModelWithPrimaryPart)

local DEFAULT_NAME = "TrackObject"

local TrackObjectSegment = {
	ClassName = "TrackObjectSegment";
}

TrackObjectSegment.__index = TrackObjectSegment
setmetatable(TrackObjectSegment, Segment)


function TrackObjectSegment.new()
	local self = setmetatable(Segment.new(), TrackObjectSegment)

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

function TrackObjectSegment.fromData(data)
	assert(IsData(data))

	local self = TrackObjectSegment.new()

	self.Name = data.Name or DEFAULT_NAME
	self.Object = data.Object
	self.Offset = data.Offset
	self.UseLookVector = data.UseLookVector


	return self
end


local function GetLookVectorCFrame(cframe)
    local p = cframe.Position
    local lv = cframe.LookVector

    return CFrame.new(p, p + lv)
end

local checkCreate = t.tuple(
	t.CFrame
)

function TrackObjectSegment:Create(cframe, _)
	assert(checkCreate(cframe))

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


return TrackObjectSegment