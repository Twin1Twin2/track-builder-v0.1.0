--- BaseSegment

local CFrameTrack = require(script.Parent.CFrameTrack)

local util = script.Parent.Util
local t = require(util.t)
local Promise = require(util.Promise)
local InstanceOfClass = require(util.InstanceOfClass)

local BaseSection = {
	ClassName = "BaseSection";
}

BaseSection.__index = BaseSection

BaseSection.IsType = InstanceOfClass(BaseSection)

function BaseSection.new()
	local self = setmetatable({}, BaseSection)

	self.Name = "Section"


	return self
end


function BaseSection:Destroy()
	setmetatable(self, nil)
end


local CheckCreateArgs = t.tuple(
	CFrameTrack.IsType,
	t.number,
	t.number
)

BaseSection.CheckCreate = function(cframeTrack, startPosition, endPosition)
	local argsSuccess, argsMessage
		= CheckCreateArgs(cframeTrack, startPosition, endPosition)
	if argsSuccess == false then
		return false, argsMessage
	end

	if startPosition == endPosition then
		return false, "startPosition cannot equal endPosition"
	end

	if startPosition > endPosition then
		local constrainToTrack = t.numberConstrained(0, cframeTrack.Length)
		local startSuccess, startMessage =
			constrainToTrack(startPosition)
		if startSuccess == false then
			return false, startMessage
		end

		local endSuccess, endMessage =
			constrainToTrack(endPosition)
		if endSuccess == false then
			return false, endMessage
		end
	end

	return true
end


-- CFrame
-- number
-- number
function BaseSection:Create(_, _, _)
	error("Unimplemented! " .. self.ClassName)
end


function BaseSection:CreateAsync(cframeTrack, startPosition, endPosition)
	return Promise.new(function(resolve, _, _)
		local model = self:Create(cframeTrack, startPosition, endPosition)
		resolve(model)
	end)
end


return BaseSection