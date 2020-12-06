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


BaseSection.CheckCreate = t.tuple(
	CFrameTrack.IsType,
	t.number,
	t.number
)


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