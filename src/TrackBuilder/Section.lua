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

	self.Interval = nil
	self.SectionStart = 0

	self.Optimize = true
	self.BuildEnd = true


	return self
end


local IsData = t.interface({
	Segment = Segment.IsType,

	Interval = t.numberPositive,
	SectionStart = t.number,

	Optimize = t.boolean,
	BuildEnd = t.boolean,
})

function Section.fromData(data)
	assert(IsData(data))

	local segment = data.Segment

	local self = Section.new(segment)

	self.Interval = data.Interval
	self.SectionStart = data.SectionStart

	self.Optimize = data.Optimize
	self.BuildEnd = data.BuildEnd


	return self
end


local HasSectionInstance = t.children({
	Interval = t.instanceIsA("NumberValue"),
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

	local intervalValue = instance:FindFirstChild("Interval")
	local startOffsetValue = instance:FindFirstChild("SectionStart")

	local optimizeValue = instance:FindFirstChild("Optimize")
	local buildEndValue = instance:FindFirstChild("BuildEnd")


	return Section.fromData({
		Segment = segment,

		Interval = intervalValue.Value,
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
	local interval = self.Interval
	local startOffset = self.SectionStart

	local optimize = self.Optimize
	local buildEnd = self.BuildEnd

	CreateSection(
		cframeTrack,
		startPosition,
		endPosition,
		startOffset,
		interval,
		optimize,
		buildEnd,
		buildSegment
	)
end

-- this should probably be CreateAsync():await()
function Section:Create(cframeTrack, startPosition, endPosition)
	assert(BaseSection.CheckCreate(cframeTrack, startPosition, endPosition))
	assert(startPosition ~= endPosition,
		"start position cannot be equal to end position!")

	local model = Instance.new("Model")
	model.Name = self.Name

	self:_Create(cframeTrack, startPosition, endPosition, function(startCFrame, endCFrame, index)
		local railObject = self.Segment:Create(startCFrame, endCFrame)

		railObject.Name = tostring(index)
		railObject.Parent = model
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
			local railObject = self.Segment:Create(startCFrame, endCFrame)

			railObject.Name = tostring(index)
			railObject.Parent = model

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