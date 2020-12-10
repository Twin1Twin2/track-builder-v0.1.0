--- MeshData
--- Mesh data struct for the NewSmooth Algorithm

local util = script.Parent.Parent.Util
local t = require(util.t)
local InstanceOfClass = require(util.InstanceOfClass)

local function IsValidMesh(meshName)
	return meshName == "BlockMesh"
		or meshName == "CylinderMesh"
		or meshName == "SpecialMesh"
end

local MESH_TYPES = {}
for _, enumItem in pairs(Enum.MeshType:GetEnumItems()) do
	MESH_TYPES[enumItem.Name] = true
end

local function IsValidMeshType(meshType)
	return MESH_TYPES[meshType] ~= nil
end


local MeshData = {
	ClassName = "MeshData";
}

MeshData.__index = MeshData

MeshData.IsType = InstanceOfClass(MeshData)

MeshData.IsData = t.interface({
	Mesh = t.string,
	MeshType = t.optional(t.string),

	Offset = t.Vector3,
	Scale = t.Vector3,
})


function MeshData.new()
	local self = setmetatable({}, MeshData)

	self.Mesh = "BlockMesh"
	self.MeshType = nil

	self.Offset = Vector3.new()
	self.Scale = Vector3.new()


	return self
end


function MeshData.fromData(data)
	assert(type(data) == "table",
		"Arg [1] is not a table!")

	local mesh = data.Mesh
	assert(type(mesh) == "string",
		"Mesh is not a string!")
	assert(IsValidMesh(mesh),
		"Mesh is not a valid mesh! " .. mesh)

	local meshType = data.MeshType

	if meshType ~= nil then
		assert(type(meshType) == "string",
			"MeshType is not a string or nil!")
		assert(IsValidMeshType(meshType),
			"MeshType is not a valid MeshType! " .. mesh)
	end

	local offset = data.Offset
	assert(typeof(offset) == "Vector3",
		"Offset is not a Vector3!")

	local scale = data.Scale
	assert(typeof(scale) == "Vector3",
		"Scale is not a Vector3!")

	local self = MeshData.new()

	self.Mesh = mesh
	self.MeshType = meshType

	self.Offset = offset
	self.Scale = scale


	return self
end

-- names are hard
local IsInstanceData1 = t.children({
	Mesh = t.optional(t.instanceIsA("StringValue")),
	MeshType = t.optional(t.instanceIsA("StringValue")),
	Offset = t.instanceIsA("Vector3Value"),
	Scale = t.instanceIsA("Vector3Value"),
})

local IsInstanceData2 = t.children({
	Mesh = t.instanceIsA("StringValue"),
	MeshType = t.optional(t.instanceIsA("StringValue")),

	Offset = t.instanceIsA("Vector3Value"),
	Scale = t.instanceIsA("Vector3Value"),
})

MeshData.IsInstanceData = function(instance)
	local instanceSuccess, instanceMessage =
		t.Instance(instance)
	if instanceSuccess == false then
		return false, instanceMessage
	end

	if instance:IsA("StringValue") then
		return IsInstanceData1(instance)
	else
		return IsInstanceData2(instance)
	end
end


function MeshData.fromInstance(instance)
	assert(MeshData.IsInstanceData(instance))

	local meshValue = instance:FindFirstChild("Mesh")
	if meshValue == nil and instance:IsA("StringValue") then
		meshValue = instance
	end
	assert(meshValue,
		"Missing Mesh!")
	assert(meshValue:IsA("StringValue"),
		"Mesh is not a StringValue!")
	local mesh = meshValue.Value

	local meshType
	local meshTypeValue = instance:FindFirstChild("MeshType")
	if meshTypeValue then
		if string.len(meshValue.Value) > 0 then
			meshType = meshTypeValue.Value
		end
	end

	local offsetValue = instance:FindFirstChild("Offset")
	local offset = offsetValue.Value

	local scaleValue = instance:FindFirstChild("Scale")
	local scale = scaleValue.Value

	return MeshData.fromData({
		Mesh = mesh,
		MeshType = meshType,

		Offset = offset,
		Scale = scale,
	})
end


function MeshData.CheckHasMesh(instance)
	assert(typeof(instance) == "Instance",
		"Arg [1] is not an Instance!")

	return instance:FindFirstChildOfClass("BlockMesh")
		or instance:FindFirstChildOfClass("CylinderMesh")
		or instance:FindFirstChildOfClass("SpecialMesh")
end


function MeshData.fromMesh(meshInstance)
	assert(typeof(meshInstance) == "Instance",
		"Arg [1] is not an Instance!")
	assert(IsValidMesh(meshInstance.ClassName),
		"Arg [2] is not a valid Mesh class!")

	local mesh = meshInstance.ClassName
	local meshType
	if mesh == "SpecialMesh" then
		meshType = meshInstance.MeshType
	end

	local offset = mesh.Offset
	local scale = mesh.Scale

	return MeshData.fromData({
		Mesh = mesh,
		MeshType = meshType,

		Offset = offset,
		Scale = scale,
	})
end


return MeshData