--- RectSegmentBuilder
--- Builder Pattern constructor for a RectSegment

local RectSegment = require(script.Parent.RectSegment)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local RectSegmentBuilder = {
	ClassName = "RectSegmentBuilder";
}

RectSegmentBuilder.__index = RectSegmentBuilder
setmetatable(RectSegmentBuilder, Builder)


function RectSegmentBuilder.new()
	local self = setmetatable(Builder.new(), RectSegmentBuilder)

	self.Wedge = nil

	self.P0 = Vector3.new()
	self.P1 = Vector3.new()
	self.P2 = Vector3.new()
	self.P3 = Vector3.new()


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Wedge"
})


function RectSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return RectSegment.fromData({
		Name = self.Name,

		Wedge = self.Wedge,

		P0 = self.P0,
		P1 = self.P1,
		P2 = self.P2,
		P3 = self.P3,
	})
end


function RectSegmentBuilder:WithWedge(wedge)
	assert(t.instanceIsA("WedgePart")(wedge))

	self.Wedge = wedge

	return self
end


function RectSegmentBuilder:WithP0(offset)
	assert(t.Vector3(offset))

	self.P0 = offset

	return self
end


function RectSegmentBuilder:WithP1(offset)
	assert(t.Vector3(offset))

	self.P1 = offset

	return self
end


function RectSegmentBuilder:WithP2(offset)
	assert(t.Vector3(offset))

	self.P2 = offset

	return self
end


function RectSegmentBuilder:WithP3(offset)
	assert(t.Vector3(offset))

	self.P3 = offset

	return self
end


return RectSegmentBuilder