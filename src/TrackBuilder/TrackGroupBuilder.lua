--- TrackGroupBuilder
--- Builder Pattern constructor for a TrackGroup

local TrackGroup = require(script.Parent.TrackGroup)
local BaseSection = require(script.Parent.BaseSection)

local Builder = require(script.Parent.Builder)

local util = script.Parent.Util
local t = require(util.t)


local TrackGroupBuilder = {
	ClassName = "TrackGroupBuilder";
}

TrackGroupBuilder.__index = TrackGroupBuilder
setmetatable(TrackGroupBuilder, Builder)


function TrackGroupBuilder.new()
	local self = setmetatable(Builder.new(), TrackGroupBuilder)

	self.Sections = {}
	self.Interval = nil


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Interval"
})


function TrackGroupBuilder:Build()
	assert(BuilderCheck(self))

	return TrackGroup.fromData({
		Name = self.Name,

		Sections = self.Sections,
		Interval = self.Interval,
	})
end


function TrackGroupBuilder:WithSection(section)
	assert(BaseSection.IsType(section))

	table.insert(self.Sections, section)

	return self
end


function TrackGroupBuilder:WithInterval(interval)
	assert(t.numberPositive(interval))

	self.Interval = interval

	return self
end


return TrackGroupBuilder