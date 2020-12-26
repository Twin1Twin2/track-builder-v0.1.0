--- Section
---

local Segment = require(script.Parent.Segment)
local BaseSection = require(script.Parent.BaseSection)

local util = script.Parent.Util
local t = require(util.t)
local Promise = require(util.Promise)

local CreateSection = require(script.Parent.CreateSection)


local Section = {
	ClassName = "Section";
}

Section.__index = Section
setmetatable(Section, BaseSection)


function Section.new(segment)
	assert(Segment.IsType(segment))

	local self = setmetatable(BaseSection.new(), Section)

	self.Name = segment.Name

	self.Segment = segment

	self.SegmentLength = nil
	self.SegmentOffset = 0

	self.SectionStart = 0

	self.Optimize = true
	self.BuildEnd = true


	return self
end


local IsData = t.interface({
	Name = t.optional(t.string),

	Segment = Segment.IsType,

	SegmentLength = t.numberPositive,
	SegmentOffset = t.optional(t.number),

	SectionStart = t.optional(t.number),

	Optimize = t.boolean,
	BuildEnd = t.boolean,
})

function Section.fromData(data)
	assert(IsData(data))

	local segment = data.Segment

	local self = Section.new(segment)

	self.Name = data.Name or segment.Name

	self.SegmentLength = data.SegmentLength
	self.SegmentOffset = data.SegmentOffset or 0

	self.SectionStart = data.SectionStart or 0

	self.Optimize = data.Optimize
	self.BuildEnd = data.BuildEnd


	return self
end


local HasSectionInstance = t.children({
	SegmentLength = t.instanceIsA("NumberValue"),
	SegmentOffset = t.instanceIsA("NumberValue"),
	SectionStart = t.instanceIsA("NumberValue"),

	Optimize = t.instanceOf("BoolValue"),
	BuildEnd = t.instanceOf("BoolValue"),

	Segment = t.optional(t.union(
		t.instanceIsA("Folder"),
		t.instanceIsA("Model")
	))
})

Section.IsInstanceData = function(instance)
	local sectionSuccess, sectionMessage = HasSectionInstance(instance)
	if sectionSuccess == false then
		return false, sectionMessage
	end

	local segmentInstance = instance:FindFirstChild("Segment")
	if segmentInstance == nil then
		segmentInstance = instance
	end

	local segmentSuccess, segmentMessage = Segment.CheckInstance(segmentInstance)
	if segmentSuccess == false then
		return false, segmentMessage
	end

	return true
end

function Section.fromInstance(instance)
	assert(Section.IsInstanceData(instance))

	local segmentInstance = instance:FindFirstChild("Segment")
	if segmentInstance == nil then
		segmentInstance = instance
	end

	local segment = Segment.CreateFromInstance(segmentInstance)

	local segmentLengthValue = instance:FindFirstChild("SegmentLength")
	local segmentOffsetValue = instance:FindFirstChild("SegmentOffset")

	local startOffsetValue = instance:FindFirstChild("SectionStart")

	local optimizeValue = instance:FindFirstChild("Optimize")
	local buildEndValue = instance:FindFirstChild("BuildEnd")


	return Section.fromData({
		Name = instance.Name,

		Segment = segment,

		SegmentLength = segmentLengthValue.Value,
		SegmentOffset = segmentOffsetValue.Value,

		SectionStart = startOffsetValue.Value,

		Optimize = optimizeValue.Value,
		BuildEnd = buildEndValue.Value
	})
end


function Section:Destroy()
	BaseSection.Destroy(self)

	self.Segment = nil

	setmetatable(self, nil)
end


function Section:_Create(cframeTrack, startPosition, endPosition, buildSegment)
	local segmentLength = self.SegmentLength
	local segmentOffset = self.SegmentOffset
	local startOffset = self.SectionStart

	local optimize = self.Optimize
	local buildEnd = self.BuildEnd

	local optimizeFunc
	if optimize == true then
		optimizeFunc = function(startCFrame, endCFrame)
			return self.Segment:IsStraightAhead(startCFrame, endCFrame)
		end
	end

	CreateSection(
		cframeTrack,
		startPosition,
		endPosition,
		startOffset,
		segmentLength,
		segmentOffset,
		optimizeFunc,
		buildEnd,
		buildSegment
	)
end

-- this should probably be CreateAsync():await()
function Section:Create(cframeTrack, startPosition, endPosition)
	assert(BaseSection.CheckCreate(cframeTrack, startPosition, endPosition))

	local model = Instance.new("Model")
	model.Name = self.Name

	self:_Create(cframeTrack, startPosition, endPosition, function(startCFrame, endCFrame, index)
		local segment = self.Segment:Create(startCFrame, endCFrame)

		segment.Name = tostring(index)
		segment.Parent = model
	end)

	return model
end


function Section:CreateAsync(cframeTrack, startPosition, endPosition)
	assert(BaseSection.CheckCreate(cframeTrack, startPosition, endPosition))
	assert(startPosition ~= endPosition,
		"start position cannot be equal to end position!")

	local model = Instance.new("Model")
	model.Name = self.Name

	local promises = {}

	self:_Create(cframeTrack, startPosition, endPosition, function(startCFrame, endCFrame, index)
		local promise = Promise.new(function(resolve)
			local segment = self.Segment:Create(startCFrame, endCFrame)

			segment.Name = tostring(index)
			segment.Parent = model

			resolve()
		end)
		:catch(function(err)
			warn(err)
		end)

		table.insert(promises, promise)
	end)

	return Promise.all(promises)
		:andThen(function()
			print("Section Finished!")
		end)
		:andThenReturn(model)
end


return Section