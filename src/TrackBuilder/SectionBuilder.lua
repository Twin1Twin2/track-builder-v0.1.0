--- SectionBuilder
--- Builder Pattern constructor for a Section

local Section = require(script.Parent.Section)
local Segment = require(script.Parent.Segment)
local Builder = require(script.Parent.Builder)

local util = script.Parent.Util
local t = require(util.t)


local SectionBuilder = {
	ClassName = "SectionBuilder";
}

SectionBuilder.__index = SectionBuilder
setmetatable(SectionBuilder, Builder)


function SectionBuilder.new()
	local self = setmetatable(Builder.new(), SectionBuilder)

	self.Segment = nil

	self.Interval = nil
	self.SectionStart = 0

	self.Optimize = true
	self.BuildEnd = true


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Segment",
	"Interval"
})


function SectionBuilder:Build()
	assert(BuilderCheck(self))

	return Section.fromData({
		Name = self.Name,

		Segment = self.Segment,

		Interval = self.Interval,
		SectionStart = self.SectionStart,
		Optimize = self.Optimize,
		BuildEnd = self.BuildEnd,
	})
end


function SectionBuilder:WithSegment(segment)
	assert(Segment.IsType(segment))

	self.Segment = segment

	return self
end


function SectionBuilder:WithInterval(interval)
	assert(t.numberPositive(interval))

	self.Interval = interval

	return self
end


function SectionBuilder:WithSectionStart(offset)
	assert(t.number(offset))

	self.SectionStart = offset

	return self
end


function SectionBuilder:WithBottomLeft(offset)
	assert(t.Vector3(offset))

	self.BottomLeft = offset

	return self
end


function SectionBuilder:WithOptimize(value)
	assert(t.boolean(value))

	self.Optimize = value

	return self
end


function SectionBuilder:WithBuildEnd(value)
	assert(t.boolean(value))

	self.BuildEnd = value

	return self
end


return SectionBuilder