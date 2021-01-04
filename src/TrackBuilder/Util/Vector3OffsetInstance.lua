--- Vector3OffsetInstance
--

local t = require(script.Parent.t)
local Vector3Instance = require(script.Parent.Vector3Instance)
local GetVector3Instance = Vector3Instance.Get

local Vector3OffsetInstance = {}

Vector3OffsetInstance.IsInstanceData = t.union(
	Vector3Instance.Check,
	t.every(
		t.instanceOf("Folder"),
		t.children({
			Origin = Vector3Instance.Check,
			Offset = Vector3Instance.Check,
		})
	)
)

Vector3OffsetInstance.Check = function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	return Vector3OffsetInstance.IsInstanceData(value)
end


Vector3OffsetInstance.Get = function(instance)
	if instance:IsA("Folder") == false then
		return GetVector3Instance(instance)
	end

	local originValue = instance:FindFirstChild("Origin")
	if originValue == nil then
		return nil, "missing Origin"
	end

	local origin, originMessage
		= GetVector3Instance(originValue)
	if origin == nil then
		return nil, originMessage
	end

	local offsetValue = instance:FindFirstChild("Offset")
	if offsetValue == nil then
		return nil, "missing Offset"
	end
	local offset, offsetMessage
		= GetVector3Instance(offsetValue)
	if offset == nil then
		return nil, offsetMessage
	end

	return offset - origin
end


Vector3OffsetInstance.CheckAndGet = function(value)
	local success, message
		= Vector3OffsetInstance.Check(value)
	if success == false then
		return false, message
	end

	return Vector3OffsetInstance.Get(value)
end


return Vector3OffsetInstance