--- CrossbeamSegment

local Segment = require(script.Parent.Segment)
local MeshData = require(script.Parent.MeshData)

local segmentUtil = script.Parent.Util
local NewSmooth = require(segmentUtil.NewSmooth)

local util = script.Parent.Parent.Util
local t = require(util.t)

local DEFAULT_RAIL_NAME = "Rail"

local CrossbeamSegment = {
	ClassName = "CrossbeamSegment";
}

CrossbeamSegment.__index = CrossbeamSegment
setmetatable(CrossbeamSegment, Segment)


function CrossbeamSegment.new()
	local self = setmetatable(Segment.new(), CrossbeamSegment)

	self.Name = DEFAULT_RAIL_NAME

	self.BasePart = nil
	self.Offset = Vector3.new()
	self.Size = Vector3.new()
	self.Rotation = Vector3.new()
	self.Horizontal = false
	self.MeshData = nil


	return self
end

local IsData = t.interface({
	Name = t.optional(t.string),

	BasePart = t.instanceIsA("BasePart"),
	StartOffset = t.Vector3,
	EndOffset = t.Vector3,
	Size = t.Vector3,
	Rotation = t.Vector3,
	Horizontal = t.boolean,
	MeshData = t.optional(MeshData.IsData)
})

function CrossbeamSegment.fromData(data)
	assert(IsData(data))

	local meshData = data.MeshData
	if meshData and MeshData.IsType(meshData) == false then
		meshData = MeshData.fromData(meshData)
	end

	local self = CrossbeamSegment.new()

	self.Name = data.Name or DEFAULT_RAIL_NAME

	self.BasePart = data.BasePart
	self.StartOffset = data.StartOffset
	self.EndOffset = data.EndOffset
	self.Size = data.Size
	self.Rotation = data.Rotation
	self.Horizontal = data.Horizontal
	self.MeshData = meshData

	return self
end


local checkCreate = t.tuple(
	t.CFrame,
	t.CFrame
)

function CrossbeamSegment:Create(startCFrame, endCFrame)
	assert(checkCreate(startCFrame, endCFrame))

	local basePart = self.BasePart:Clone()

	local cframe, size, mesh
		= NewSmooth(
			startCFrame,
			self.StartOffset,
			endCFrame,
			self.EndOffset,
			self.Size,
			self.Rotation,
			self.Horizontal,
			self.MeshData
		)

	basePart.CFrame = cframe
	basePart.Size = size

	if mesh then
		mesh.Parent = basePart
	end

	return basePart
end


return CrossbeamSegment