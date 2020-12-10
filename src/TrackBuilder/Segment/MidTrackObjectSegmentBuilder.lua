--- MidTrackObjectSegmentBuilder
--- Builder Pattern constructor for a MidTrackObjectSegment

local MidTrackObjectSegment = require(script.Parent.MidTrackObjectSegment)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)
local IsModelWithPrimaryPart = require(util.IsModelWithPrimaryPart)


local MidTrackObjectSegmentBuilder = {
	ClassName = "MidTrackObjectSegmentBuilder";
}

MidTrackObjectSegmentBuilder.__index = MidTrackObjectSegmentBuilder
setmetatable(MidTrackObjectSegmentBuilder, Builder)


function MidTrackObjectSegmentBuilder.new()
	local self = setmetatable(Builder.new(), MidTrackObjectSegmentBuilder)

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


function MidTrackObjectSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return MidTrackObjectSegment.fromData({
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

function MidTrackObjectSegmentBuilder:WithObject(object)
	assert(IsObject(object))

	self.Object = object

	return self
end


function MidTrackObjectSegmentBuilder:WithOffset(offset)
	assert(t.CFrame(offset))

	self.Offset = offset

	return self
end


function MidTrackObjectSegmentBuilder:WithUseLookVector(value)
	assert(t.boolean(value))

	self.UseLookVector = value

	return self
end


return MidTrackObjectSegmentBuilder