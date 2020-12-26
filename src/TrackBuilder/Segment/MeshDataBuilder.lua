--- MeshDataBuilder
--- Builder Pattern constructor for a MeshData

local MeshData = require(script.Parent.MeshData)

local root = script.Parent.Parent
local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local MeshDataBuilder = {
	ClassName = "MeshDataBuilder";
}

MeshDataBuilder.__index = MeshDataBuilder
setmetatable(MeshDataBuilder, Builder)


function MeshDataBuilder.new()
	local self = setmetatable(Builder.new(), MeshDataBuilder)

	self.Mesh = nil
	self.MeshType = nil

	self.Offset = Vector3.new(0, 0, 0)
	self.Scale = Vector3.new(1, 1, 1)


	return self
end

-- makes sure everything is setup properly
-- runs an "any" check on the following properties
local BuilderCheck = Builder.Check({
	"Mesh"
})


function MeshDataBuilder:Build()
	assert(BuilderCheck(self))

	return MeshData.fromData({
		Mesh = self.Mesh,
		MeshType = self.MeshType,

		Offset = self.Offset,
		Scale = self.Scale,
	})
end


function MeshDataBuilder:WithMesh(meshName)
	assert(MeshData.IsMeshClassName(meshName))

	self.Mesh = meshName

	return self
end


function MeshDataBuilder:WithMeshType(meshType)
	assert(t.optional(MeshData.IsMeshType)(meshType))

	self.MeshType = meshType

	return self
end


function MeshDataBuilder:WithOffset(offset)
	assert(t.Vector3(offset))

	self.Offset = offset

	return self
end


function MeshDataBuilder:WithScale(scale)
	assert(t.Vector3(scale))

	self.Scale = scale

	return self
end


return MeshDataBuilder