--- TrackObjectSegmentBuilder
--- Builder Pattern constructor for a TrackObjectSegment

local TrackObjectSegment = require(script.Parent.TrackObjectSegment)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)
local IsModelWithPrimaryPart = require(util.IsModelWithPrimaryPart)


local TrackObjectSegmentBuilder = {
	ClassName = "TrackObjectSegmentBuilder";
}

TrackObjectSegmentBuilder.__index = TrackObjectSegmentBuilder
setmetatable(TrackObjectSegmentBuilder, Builder)


function TrackObjectSegmentBuilder.new()
	local self = setmetatable(Builder.new(), TrackObjectSegmentBuilder)

	self.Name = nil

	self.Object = nil
	self.Offset = CFrame.new()

	self.UseLookVector = false


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Object"
})


function TrackObjectSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return TrackObjectSegment.fromData({
		Name = self.Name,

		Object = self.Object,
		Offset = self.Offset,

		UseLookVector = self.UseLookVector,
	})
end

local IsObject = t.union(
	t.instanceIsA("BasePart"),
	IsModelWithPrimaryPart
)

function TrackObjectSegmentBuilder:WithObject(object)
	assert(IsObject(object))

	self.Object = object

	return self
end


function TrackObjectSegmentBuilder:WithOffset(offset)
	assert(t.CFrame(offset))

	self.Offset = offset

	return self
end


function TrackObjectSegmentBuilder:WithUseLookVector(value)
	assert(t.boolean(value))

	self.UseLookVector = value

	return self
end


return TrackObjectSegmentBuilder