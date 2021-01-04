--- Vector3Instance
--

local t = require(script.Parent.t)
local ReduceObjectValue = require(script.Parent.ReduceObjectValue)
local IsModelWithPrimaryPart = require(script.Parent.IsModelWithPrimaryPart)

local Vector3Instance = {}

local isValidVector3Instance = t.union(
	t.instanceIsA("Vector3Value"),
	t.instanceIsA("CFrameValue"),
	t.instanceIsA("BasePart"),
	t.instanceIsA("Attachment"),
	IsModelWithPrimaryPart
)

Vector3Instance.Check = function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	local _value, reduceObjectMessage = ReduceObjectValue(value)
	if _value == false then
		return false, reduceObjectMessage
	end
	value = _value

	return isValidVector3Instance(value)
end

-- assume already checked. for performance
Vector3Instance.Get = function(instance)
	if instance:IsA("ObjectValue") then
		instance = instance.Value
	end

	if instance:IsA("Vector3Value") then
		return instance.Value
	elseif instance:IsA("CFrameValue") then
		return instance.Value.Position
	elseif instance:IsA("BasePart") then
		return instance.Position
	elseif instance:IsA("Attachment") then
		return instance.WorldPosition
	elseif instance:IsA("Model") then
		return instance:GetPrimaryPartCFrame().Position
	end

	return false,
		"invalid instance! ClassName = " .. instance.ClassName .. "; Path = " .. instance:GetFullName()
end


Vector3Instance.CheckAndGet = function(value)
	local success, message
		= Vector3Instance.Check(value)
	if success == false then
		return false, message
	end

	return Vector3Instance.Get(value)
end


return Vector3Instance