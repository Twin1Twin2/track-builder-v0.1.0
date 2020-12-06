--- Physics Rails

local BaseSection = require(script.Parent.BaseSection)
local CreateSection = require(script.Parent.CreateSection)

local Segment = require(script.Parent.Segment)
local RailSegment = Segment.Rail

local ZERO_FRICTION_PHYSICAL_PROPERTIES = PhysicalProperties.new(
	1,
	0,
	0
)

local SPEED_PHYSICAL_PROPERTIES = PhysicalProperties.new(
	1,
	1,
	0
)

local PhysicsRails = {
	ClassName = "PhysicsRails";
}

PhysicsRails.__index = PhysicsRails
setmetatable(PhysicsRails, BaseSection)


function PhysicsRails.new()
	local self = setmetatable(BaseSection.new(), PhysicsRails)

	self.Name = "PhysicsRails"

	self.Rails = {}
	self.Interval = 5


	return self
end


local HORIZONTAL_ROTATION = CFrame.Angles(math.pi/2, 0, 0)

function PhysicsRails:CreateSegment(startCFrame, endCFrame, speed)
	local model = Instance.new("Model")

	for _, railSegment in ipairs(self.Rails) do
		local basePart = railSegment:Create(startCFrame, endCFrame)

		-- temporary
		if speed < 0.01 then -- because floats
			basePart.CustomPhysicalProperties = ZERO_FRICTION_PHYSICAL_PROPERTIES
		else
			basePart.CustomPhysicalProperties = SPEED_PHYSICAL_PROPERTIES
		end

		if railSegment.Horizontal == true then
			basePart.Velocity = (basePart.CFrame * HORIZONTAL_ROTATION).LookVector * speed
		else
			basePart.Velocity = basePart.CFrame.LookVector * speed
		end

		basePart.Parent = model
	end

	return model
end


function PhysicsRails:Create(cframeTrack, startPosition, endPosition, speed)
	speed = speed or 0	-- if added to a TrackSection, default to 0

	local startOffset = 0
	local interval = self.Interval
	local optimize = false
	local buildEnd = false

	local model = Instance.new("Model")
	model.Name = self.Name

	local function buildSegment(startCFrame, endCFrame, index, _, _)
		-- get speed from progress
		-- local progress = math.clamp(midPosition / sectionLength, 0, 1)

		local segment = self:CreateSegment(
			startCFrame,
			endCFrame,
			speed
		)

		segment.Name = tostring(index)
		segment.Parent = model
	end

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

	return model
end


function PhysicsRails:Add(railSegment)
	assert(RailSegment.IsType(railSegment))

	table.insert(self.Rails, railSegment)
end


function PhysicsRails:AddFromSection(railSection)
	table.insert(self.Rails, railSection.Segment)
end


return PhysicsRails