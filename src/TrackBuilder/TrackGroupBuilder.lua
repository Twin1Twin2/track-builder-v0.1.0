--- TrackGroupBuilder
--- Builder Pattern constructor for a TrackGroup

local TrackGroup = require(script.Parent.TrackGroup)
local BaseSection = require(script.Parent.BaseSection)

local Builder = require(script.Parent.Builder)

local TrackGroupBuilder = {
	ClassName = "TrackGroupBuilder";
}

TrackGroupBuilder.__index = TrackGroupBuilder
setmetatable(TrackGroupBuilder, Builder)


function TrackGroupBuilder.new()
	local self = setmetatable(Builder.new(), TrackGroupBuilder)

	self.Sections = {}

	return self
end


function TrackGroupBuilder:Build()
	return TrackGroup.fromData({
		Name = self.Name,

		Sections = self.Sections,
	})
end


function TrackGroupBuilder:WithSection(section)
	assert(BaseSection.IsType(section))

	table.insert(self.Sections, section)

	return self
end


return TrackGroupBuilder