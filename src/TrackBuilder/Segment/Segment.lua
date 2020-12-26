--- Segment
--- Builds an Instance, usually a Model or a BasePart from either 1 or 2 CFrames
---

local segmentUtil = script.Parent.Util
local IsCFrameStraightAhead = require(segmentUtil.IsCFrameStraightAhead)

local util = script.Parent.Parent.Util
local InstanceOfClass = require(util.InstanceOfClass)
local Promise = require(util.Promise)

local Segment = {
	ClassName = "Segment";
}

Segment.__index = Segment

Segment.IsType = InstanceOfClass(Segment)

function Segment.new()
	local self = setmetatable({}, Segment)

	self.Name = "Segment"


	return self
end


function Segment:Destroy()
	setmetatable(self, nil)
end


function Segment.IsStraightAhead(_, startCFrame, endCFrame)
	return IsCFrameStraightAhead(startCFrame, endCFrame)
end


function Segment:Create(_, _)
	error("Unimplemented! " .. self.ClassName)
end


function Segment:CreateAsync(startCFrame, endCFrame)
	return Promise.new(function(resolve, _, _)
		local model = self:Create(startCFrame, endCFrame)
		resolve(model)
	end)
end


return Segment