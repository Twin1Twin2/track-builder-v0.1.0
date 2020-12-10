--- CrossbeamSegmentBuilder
--- Builder Pattern constructor for a CrossbeamSegment

local CrossbeamSegment = require(script.Parent.CrossbeamSegment)
local MeshData = require(script.Parent.MeshData)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local CrossbeamSegmentBuilder = {
	ClassName = "CrossbeamSegmentBuilder";
}

CrossbeamSegmentBuilder.__index = CrossbeamSegmentBuilder
setmetatable(CrossbeamSegmentBuilder, Builder)


function CrossbeamSegmentBuilder.new()
	local self = setmetatable(Builder.new(), CrossbeamSegmentBuilder)

	self.BasePart = nil
	self.StartOffset = Vector3.new()
	self.EndOffset = Vector3.new()
	self.Size = nil
	self.Rotation = Vector3.new()
	self.Horizontal = false
	self.MeshData = nil


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"BasePart"
})


function CrossbeamSegmentBuilder:Build()
	assert(BuilderCheck(self))

	local size = self.Size
	if size == nil then
		size = self.BasePart.Size
	end

	return CrossbeamSegment.fromData({
		Name = self.Name,

		BasePart = self.BasePart,
		StartOffset = self.StartOffset,
		EndOffset = self.EndOffset,
		Size = size,
		Rotation = self.Rotation,
		Horizontal = self.Horizontal,
		MeshData = self.MeshData,
	})
end


function CrossbeamSegmentBuilder:WithBasePart(basePart)
	assert(t.instanceIsA("BasePart")(basePart))

	self.BasePart = basePart

	return self
end


function CrossbeamSegmentBuilder:WithStartOffset(offset)
	assert(t.Vector3(offset))

	self.StartOffset = offset

	return self
end


function CrossbeamSegmentBuilder:WithEndOffset(offset)
	assert(t.Vector3(offset))

	self.EndOffset = offset

	return self
end


function CrossbeamSegmentBuilder:WithSize(size)
	assert(t.Vector3(size))

	self.Size = size

	return self
end


function CrossbeamSegmentBuilder:WithRotation(rotation)
	assert(t.Vector3(rotation))

	self.Rotation = rotation

	return self
end


function CrossbeamSegmentBuilder:WithHorizontal(value)
	assert(t.boolean(value))

	self.Horizontal = value

	return self
end


function CrossbeamSegmentBuilder:WithMeshData(value)
	assert(MeshData.IsData(value))

	self.MeshData = value

	return self
end


return CrossbeamSegmentBuilder