--- RectRailSegmentBuilder
--- Builder Pattern constructor for a RectRailSegment

local RectRailSegment = require(script.Parent.RectRailSegment)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local RectRailSegmentBuilder = {
	ClassName = "RectRailSegmentBuilder";
}

RectRailSegmentBuilder.__index = RectRailSegmentBuilder
setmetatable(RectRailSegmentBuilder, Builder)


function RectRailSegmentBuilder.new()
	local self = setmetatable(Builder.new(), RectRailSegmentBuilder)

	self.Wedge = nil

	self.StartOffset1 = Vector3.new()
	self.StartOffset2 = Vector3.new()
	self.EndOffset1 = Vector3.new()
	self.EndOffset2 = Vector3.new()

	self.UseStart = false


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Wedge"
})


function RectRailSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return RectRailSegment.fromData({
		Name = self.Name,

		Wedge = self.Wedge,

		UseStart = self.UseStart,

		StartOffset1 = self.StartOffset1,
		StartOffset2 = self.StartOffset2,
		EndOffset1 = self.EndOffset1,
		EndOffset2 = self.EndOffset2,
	})
end


function RectRailSegmentBuilder:WithWedge(wedge)
	assert(t.instanceIsA("WedgePart")(wedge))

	self.Wedge = wedge

	return self
end


function RectRailSegmentBuilder:WithUseStart(value)
	assert(t.boolean(value))

	self.UseStart = value

	return self
end


function RectRailSegmentBuilder:WithStartOffset1(offset)
	assert(t.Vector3(offset))

	self.StartOffset1 = offset

	return self
end


function RectRailSegmentBuilder:WithStartOffset2(offset)
	assert(t.Vector3(offset))

	self.StartOffset2 = offset

	return self
end


function RectRailSegmentBuilder:WithEndOffset1(offset)
	assert(t.Vector3(offset))

	self.EndOffset1 = offset

	return self
end


function RectRailSegmentBuilder:WithEndOffset2(offset)
	assert(t.Vector3(offset))

	self.EndOffset2 = offset

	return self
end


return RectRailSegmentBuilder