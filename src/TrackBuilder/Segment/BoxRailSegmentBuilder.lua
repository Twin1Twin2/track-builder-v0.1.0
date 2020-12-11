--- BoxRailSegmentBuilder
--- Builder Pattern constructor for a BoxRailSegment

local BoxRailSegment = require(script.Parent.BoxRailSegment)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local BoxRailSegmentBuilder = {
	ClassName = "BoxRailSegmentBuilder";
}

BoxRailSegmentBuilder.__index = BoxRailSegmentBuilder
setmetatable(BoxRailSegmentBuilder, Builder)


function BoxRailSegmentBuilder.new()
	local self = setmetatable(Builder.new(), BoxRailSegmentBuilder)

	self.Wedge = nil

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

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Wedge"
})


function BoxRailSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return BoxRailSegment.fromData({
		Name = self.Name,

		Wedge = self.Wedge,

		TopLeft = self.TopLeft,
		TopRight = self.TopRight,
		BottomLeft = self.BottomLeft,
		BottomRight = self.BottomRight,

		DrawTop = self.DrawTop,
		DrawBottom = self.DrawBottom,
		DrawLeft = self.DrawLeft,
		DrawRight = self.DrawRight,
	})
end


function BoxRailSegmentBuilder:WithWedge(wedge)
	assert(t.instanceIsA("WedgePart")(wedge))

	self.Wedge = wedge

	return self
end


function BoxRailSegmentBuilder:WithTopLeft(offset)
	assert(t.Vector3(offset))

	self.TopLeft = offset

	return self
end


function BoxRailSegmentBuilder:WithTopRight(offset)
	assert(t.Vector3(offset))

	self.TopRight = offset

	return self
end


function BoxRailSegmentBuilder:WithBottomLeft(offset)
	assert(t.Vector3(offset))

	self.BottomLeft = offset

	return self
end


function BoxRailSegmentBuilder:WithBottomRight(offset)
	assert(t.Vector3(offset))

	self.BottomRight = offset

	return self
end


function BoxRailSegmentBuilder:WithDrawTop(value)
	assert(t.boolean(value))

	self.DrawTop = value

	return self
end


function BoxRailSegmentBuilder:WithDrawBottom(value)
	assert(t.boolean(value))

	self.DrawBottom = value

	return self
end


function BoxRailSegmentBuilder:WithDrawLeft(value)
	assert(t.boolean(value))

	self.DrawLeft = value

	return self
end


function BoxRailSegmentBuilder:WithDrawRight(value)
	assert(t.boolean(value))

	self.DrawRight = value

	return self
end


return BoxRailSegmentBuilder