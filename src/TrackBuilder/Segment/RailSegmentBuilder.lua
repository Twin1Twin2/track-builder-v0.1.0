--- RailSegmentBuilder
--- Builder Pattern constructor for a RailSegment

local RailSegment = require(script.Parent.RailSegment)
local MeshData = require(script.Parent.MeshData)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local RailSegmentBuilder = {
	ClassName = "RailSegmentBuilder";
}

RailSegmentBuilder.__index = RailSegmentBuilder
setmetatable(RailSegmentBuilder, Builder)


function RailSegmentBuilder.new()
	local self = setmetatable(Builder.new(), RailSegmentBuilder)

	self.Name = nil

	self.BasePart = nil
	self.Offset = Vector3.new()
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


function RailSegmentBuilder:Build()
	assert(BuilderCheck(self))

	return RailSegment.fromData({
		Name = self.Name,

		BasePart = self.BasePart,
		Offset = self.Offset,
		Size = self.Size,
		Rotation = self.Rotation,
		Horizontal = self.Horizontal,
		MeshData = self.MeshData,
	})
end


function RailSegmentBuilder:WithBasePart(basePart)
	assert(t.instanceIsA("BasePart"))

	self.BasePart = basePart

	return self
end


function RailSegmentBuilder:WithOffset(offset)
	assert(t.Vector3(offset))

	self.Offset = offset

	return self
end


function RailSegmentBuilder:WithSize(size)
	assert(t.Vector3(size))

	self.Size = size

	return self
end


function RailSegmentBuilder:WithRotation(rotation)
	assert(t.Vector3(rotation))

	self.Rotation = rotation

	return self
end


function RailSegmentBuilder:WithHorizontal(value)
	assert(t.boolean(value))

	self.Horizontal = value

	return self
end


function RailSegmentBuilder:WithMeshData(value)
	assert(MeshData.IsData(value))

	self.MeshData = value

	return self
end


return RailSegmentBuilder