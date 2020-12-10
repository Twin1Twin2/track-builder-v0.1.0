--- RailSegment

local Segment = require(script.Parent.Segment)
local MeshData = require(script.Parent.MeshData)

local segmentUtil = script.Parent.Util
local NewSmooth = require(segmentUtil.NewSmooth)

local util = script.Parent.Parent.Util
local t = require(util.t)
local InstanceOfClass = require(util.InstanceOfClass)

local DEFAULT_NAME = "Rail"

local RailSegment = {
	ClassName = "RailSegment";
}

RailSegment.__index = RailSegment
setmetatable(RailSegment, Segment)

RailSegment.IsType = InstanceOfClass(RailSegment)

function RailSegment.new()
	local self = setmetatable(Segment.new(), RailSegment)

	self.Name = DEFAULT_NAME

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
	Offset = t.Vector3,
	Size = t.Vector3,
	Rotation = t.Vector3,
	Horizontal = t.boolean,
	MeshData = t.optional(MeshData.IsData)
})

RailSegment.IsData = IsData

function RailSegment.fromData(data)
	assert(IsData(data))

	local name = data.Name or DEFAULT_NAME

	local meshData = data.MeshData
	if meshData and MeshData.IsType(meshData) == false then
		meshData = MeshData.fromData(meshData)
	end

	local self = RailSegment.new()

	self.Name = name

	self.BasePart = data.BasePart
	self.Offset = data.Offset
	self.Size = data.Size
	self.Rotation = data.Rotation
	self.Horizontal = data.Horizontal
	self.MeshData = meshData


	return self
end

RailSegment.IsInstanceData = t.children({
	BasePart = t.instanceIsA("BasePart"),
	Offset = t.optional(t.instanceIsA("Vector3Value")),
	Size = t.optional(t.instanceIsA("Vector3Value")),
	Rotation = t.instanceIsA("Vector3Value"),
	Horizontal = t.optional(t.instanceOf("BoolValue")),
	MeshData = t.optional(MeshData.IsInstanceData),
})

function RailSegment.fromInstance(instance)
	assert(RailSegment.IsInstanceData(instance))

	local basePart = instance:FindFirstChild("BasePart")
	local offsetValue = instance:FindFirstChild("Offset")
	local sizeValue = instance:FindFirstChild("Size")
	local rotationValue = instance:FindFirstChild("Rotation")
	local horizontalValue = instance:FindFirstChild("Horizontal")
	local meshDataValue = instance:FindFirstChild("MeshData")

	local offset = Vector3.new()
	if offsetValue then
		offset = offsetValue.Value
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

	return RailSegment.fromData({
		Name = instance.Name,
		BasePart = basePart,
		Offset = offset,
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

function RailSegment:Create(startCFrame, endCFrame)
	assert(checkCreate(startCFrame, endCFrame))

	local basePart = self.BasePart:Clone()

	local cframe, size, mesh
		= NewSmooth(
			startCFrame,
			self.Offset,
			endCFrame,
			self.Offset,
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


return RailSegment