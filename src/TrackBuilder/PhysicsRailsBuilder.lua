--- PhysicsRailsBuilder
--- Builder Pattern constructor for a PhysicsRails

local PhysicsRails = require(script.Parent.PhysicsRails)
local Segment = require(script.Parent.Segment)
local RailSegment = Segment.Rail

local Builder = require(script.Parent.Builder)

local util = script.Parent.Util
local t = require(util.t)


local PhysicsRailsBuilder = {
	ClassName = "PhysicsRailsBuilder";
}

PhysicsRailsBuilder.__index = PhysicsRailsBuilder
setmetatable(PhysicsRailsBuilder, Builder)


function PhysicsRailsBuilder.new()
	local self = setmetatable(Builder.new(), PhysicsRailsBuilder)

	self.Rails = {}
	self.Interval = nil


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Interval"
})


function PhysicsRailsBuilder:Build()
	assert(BuilderCheck(self))

	return PhysicsRails.fromData({
		Name = self.Name,

		Rails = self.Rails,
		Interval = self.Interval,
	})
end


function PhysicsRailsBuilder:WithRail(railSegment)
	assert(RailSegment.IsType(railSegment))

	table.insert(self.Rails, railSegment)

	return self
end


function PhysicsRailsBuilder:WithInterval(interval)
	assert(t.numberPositive(interval))

	self.Interval = interval

	return self
end


return PhysicsRailsBuilder