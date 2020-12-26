--- MeshData
--- Mesh data struct for the NewSmooth Algorithm

local util = script.Parent.Parent.Util
local t = require(util.t)
local InstanceOfClass = require(util.InstanceOfClass)

local EnumType = require(util.EnumType)
local MeshTypeType = EnumType(Enum.MeshType)

local function IsValidMesh(meshName)
	return meshName == "BlockMesh"
		or meshName == "CylinderMesh"
		or meshName == "SpecialMesh"
end


local MeshData = {
	ClassName = "MeshData";
}

MeshData.__index = MeshData

MeshData.IsType = InstanceOfClass(MeshData)


function MeshData.new()
	local self = setmetatable({}, MeshData)

	self.Mesh = "BlockMesh"
	self.MeshType = nil

	self.Offset = Vector3.new()
	self.Scale = Vector3.new()


	return self
end


MeshData.IsMeshClassName = function(meshClass)
	local strSuccess, strMessage
		= t.string(meshClass)

	if strSuccess == false then
		return false, strMessage
	end

	if IsValidMesh(meshClass) == false then
		return false, "not a valid mesh class: " .. meshClass
	end

	return true
end

MeshData.IsMeshType = MeshTypeType.Check

MeshData.IsData = t.interface({
	Mesh = MeshData.IsMeshClassName,
	MeshType = t.optional(MeshData.IsMeshType),

	Offset = t.Vector3,
	Scale = t.Vector3,
})

function MeshData.fromData(data)
	assert(MeshData.IsData(data))

	local self = MeshData.new()

	self.Mesh = data.Mesh
	self.MeshType = MeshTypeType.Get(data.MeshType)

	self.Offset = data.Offset
	self.Scale = data.Scale


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
	local mesh = meshValue.Value

	local meshType
	local meshTypeValue = instance:FindFirstChild("MeshType")
	if meshTypeValue then
		if string.len(meshValue.Value) > 0 then
			local meshTypeEnum, meshTypeMessage
				= MeshTypeType.CheckAndGet(meshTypeValue.Value)

			assert(meshTypeEnum, meshTypeMessage)

			meshType = meshTypeEnum
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