--- CFrameOffsetInstance
--

local t = require(script.Parent.t)
local CFrameInstance = require(script.Parent.CFrameInstance)
local GetCFrameInstance = CFrameInstance.Get

local CFrameOffsetInstance = {}

CFrameOffsetInstance.IsInstanceData = t.union(
	CFrameInstance.Check,
	t.every(
		t.instanceOf("Folder"),
		t.children({
			Origin = CFrameInstance.Check,
			Offset = CFrameInstance.Check,
		})
	)
)

CFrameOffsetInstance.Check = function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	return CFrameOffsetInstance.IsInstanceData(value)
end


CFrameOffsetInstance.Get = function(instance)
	if instance:IsA("Folder") == false then
		return GetCFrameInstance(instance)
	end

	local originValue = instance:FindFirstChild("Origin")
	if originValue == nil then
		return nil, "missing Origin"
	end

	local origin, originMessage
		= GetCFrameInstance(originValue)
	if origin == nil then
		return nil, originMessage
	end

	local offsetValue = instance:FindFirstChild("Offset")
	if offsetValue == nil then
		return nil, "missing Offset"
	end

	local offset, offsetMessage
		= GetCFrameInstance(offsetValue)
	if offset == nil then
		return nil, offsetMessage
	end

	return origin:ToObjectSpace(offset)
end


CFrameOffsetInstance.CheckAndGet = function(value)
	local success, message
		= CFrameOffsetInstance.Check(value)
	if success == false then
		return false, message
	end

	return CFrameOffsetInstance.Get(value)
end


return CFrameOffsetInstance