--- CrossbeamSegment

local Segment = require(script.Parent.Segment)
local MeshData = require(script.Parent.MeshData)

local segmentUtil = script.Parent.Util
local NewSmooth = require(segmentUtil.NewSmooth)

local util = script.Parent.Parent.Util
local t = require(util.t)
local Vector3OffsetInstance = require(util.Vector3OffsetInstance)
local ObjectValueUtil = require(util.ObjectValueUtil)


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
	self.StartOffset = Vector3.new()
	self.EndOffset = Vector3.new()
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

CrossbeamSegment.IsInstanceData = t.children({
	BasePart = ObjectValueUtil.Type(t.instanceIsA("BasePart")),

	StartOffset = t.optional(Vector3OffsetInstance.IsInstanceData),
	EndOffset = t.optional(Vector3OffsetInstance.IsInstanceData),

	Size = t.optional(t.instanceIsA("Vector3Value")),
	Rotation = t.instanceIsA("Vector3Value"),
	Horizontal = t.optional(t.instanceOf("BoolValue")),
	MeshData = t.optional(MeshData.IsInstanceData),
})

function CrossbeamSegment.fromInstance(instance)
	assert(CrossbeamSegment.IsInstanceData(instance))

	local basePart = instance:FindFirstChild("BasePart")
	local startOffsetValue = instance:FindFirstChild("StartOffset")
	local endOffsetValue = instance:FindFirstChild("EndOffset")
	local sizeValue = instance:FindFirstChild("Size")
	local rotationValue = instance:FindFirstChild("Rotation")
	local horizontalValue = instance:FindFirstChild("Horizontal")
	local meshDataValue = instance:FindFirstChild("MeshData")

	basePart = ObjectValueUtil.Reduce(basePart)
	basePart = basePart:Clone()

	local startOffset = Vector3.new()
	if startOffsetValue then
		startOffset = Vector3OffsetInstance.Get(startOffsetValue)
	end

	local endOffset = Vector3.new()
	if endOffsetValue then
		endOffset = Vector3OffsetInstance.Get(endOffsetValue)
	end

	local size = basePart.Size
	if sizeValue then
		size = sizeValue.Value
	end

	local rotation = Vector3.new()
	if rotationValue then
		rotation = rotationValue.Value
	end

	local horizontal = false
	if horizontalValue then
		horizontal = horizontalValue.Value
	end

	local meshData
	if meshDataValue then
		meshData = MeshData.fromInstance(meshDataValue)
	end

	return CrossbeamSegment.fromData({
		Name = instance.Name,

		BasePart = basePart,
		StartOffset = startOffset,
		EndOffset = endOffset,
		Size = size,
		Rotation = rotation,
		Horizontal = horizontal,
		MeshData = meshData
	})
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