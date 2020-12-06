
local t = require(script.Parent.t)
local ReduceObjectValue = require(script.Parent.ReduceObjectValue)

local Vector3FromInstance = {}

local isValidVector3Instance = t.union(
	t.instanceIsA("CFrameValue"),
	t.instanceIsA("Vector3Value"),
	t.instanceIsA("BasePart"),
	t.instanceIsA("Attachment")
)

Vector3FromInstance.Check = function(value)
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
Vector3FromInstance.Get = function(instance)
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
	end

	-- idk how it will get here, but hey
	return false, "Invalid Instance! ClassName = " .. instance.ClassName .. "; Path = " .. instance:GetFullName()
end


Vector3FromInstance.CheckAndGet = function(value)
	local success, message
		= Vector3FromInstance.Check(value)
	if success == false then
		return false, message
	end

	return Vector3FromInstance.Get(value)
end


return Vector3FromInstance