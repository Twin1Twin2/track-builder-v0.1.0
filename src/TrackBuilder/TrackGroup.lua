--- TrackGroup

local BaseSection = require(script.Parent.BaseSection)
local Section = require(script.Parent.Section)

local util = script.Parent.Util
local t = require(util.t)
local Promise = require(util.Promise)

local DEFAULT_NAME = "TrackGroup"
local ASSETS_NAME = "ASSETS"

local TrackGroup = {
	ClassName = "TrackGroup";
}

TrackGroup.__index = TrackGroup
setmetatable(TrackGroup, BaseSection)


function TrackGroup.new()
	local self = setmetatable(BaseSection.new(), TrackGroup)

	self.Name = DEFAULT_NAME

	self.Sections = {}


	return self
end


local IsData = t.interface({
	Name = t.optional(t.string),

	Sections = t.array(BaseSection.IsType)
})

function TrackGroup.fromData(data)
	assert(IsData(data))

	local self = TrackGroup.new()

	self.Name = data.Name or DEFAULT_NAME
	self.Sections = data.Sections


	return self
end


-- -- assumes every table needs to be turned into a Section class
-- function TrackGroup.fromRawData(data)
-- 	assert(IsData(data))

-- 	local self = TrackGroup.new()

-- 	self.Name = data.Name or DEFAULT_NAME
-- 	self.Sections = data.Sections


-- 	return self
-- end


TrackGroup.IsInstanceData = function(instance)
	local instanceSuccess, instanceMessage
		= t.Instance(instance)
	if instanceSuccess == false then
		return false, instanceMessage
	end

	local childrenSuccess = true
	local childrenMessages = {}

	local children = instance:GetChildren()
	for _, child in pairs(children) do
		if child.Name ~= ASSETS_NAME then
			local sectionSuccess, sectionMessage

			if child:IsA("Configuration") then
				sectionSuccess, sectionMessage
					= TrackGroup.IsInstanceData(child)
			else
				sectionSuccess, sectionMessage
					= Section.IsInstanceData(child)
			end

			if sectionSuccess == false then
				childrenSuccess = false
				table.insert(childrenMessages, sectionMessage)
			end
		end
	end

	if childrenSuccess == false then
		local message = "Invalid!"
		for _, childrenMessage in ipairs(childrenMessages) do
			message = message .. "\n" .. childrenMessage
		end

		return false, message
	end

	return true
end

function TrackGroup.fromInstance(instance)
	assert(TrackGroup.IsInstanceData(instance))

	local sections = {}

	for _, child in pairs(instance:GetChildren()) do
		if child.Name ~= ASSETS_NAME then
			local section

			if child:IsA("Configuration") then
				section = TrackGroup.fromInstance(child)
			else
				section = Section.fromInstance(child)
			end

			table.insert(sections, section)
		end
	end

	return TrackGroup.fromData({
		Name = instance.Name,
		Sections = sections,
	})
end


function TrackGroup:Destroy()
	BaseSection.Destroy(self)

	self.Sections = nil

	setmetatable(self, nil)
end


function TrackGroup:Create(cframeTrack, startPosition, endPosition)
	assert(BaseSection.CheckCreate(cframeTrack, startPosition, endPosition))

	local model = Instance.new("Model")
	model.Name = self.Name

	for _, section in ipairs(self.Sections) do
		local sectionModel = section:Create(cframeTrack, startPosition, endPosition)
		sectionModel.Parent = model
	end

	return model
end


function TrackGroup:CreateAsync(cframeTrack, startPosition, endPosition)
	assert(BaseSection.CheckCreate(cframeTrack, startPosition, endPosition))

	local promises = {}

	local model = Instance.new("Model")
	model.Name = self.Name

	for _, section in ipairs(self.Sections) do
		local promise = section:CreateAsync(cframeTrack, startPosition, endPosition)
			:andThen(function(sectionModel)
				sectionModel.Parent = model
			end)
			:catch(function(err)
				warn(err)
			end)

		table.insert(promises, promise)
	end

	return Promise.all(promises)
		:andThenReturn(model)
end


function TrackGroup:Add(section)
	assert(BaseSection.IsType(section))

	table.insert(self.Sections, section)
end



return TrackGroup