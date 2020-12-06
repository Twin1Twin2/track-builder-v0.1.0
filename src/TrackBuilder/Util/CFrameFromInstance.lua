
local t = require(script.Parent.t)
local ReduceObjectValue = require(script.Parent.ReduceObjectValue)

local CFrameFromInstance = {}

local isValidCFrameInstance = t.union(
	t.instanceIsA("CFrameValue"),
	t.instanceIsA("Vector3Value"),
	t.instanceIsA("BasePart"),
	t.instanceIsA("Attachment")
)

CFrameFromInstance.Check = function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	local _value, reduceObjectMessage = ReduceObjectValue(value)
	if _value == false then
		return false, reduceObjectMessage
	end
	value = _value

	return isValidCFrameInstance(value)
end


CFrameFromInstance.Get = function(instance)
	if instance:IsA("ObjectValue") then
		instance = instance.Value
	end

    if instance:IsA("CFrameValue") then
        return instance.Value
    elseif instance:IsA("Vector3Value") then
        return CFrame.new(instance.Value)
    elseif instance:IsA("BasePart") then
        return instance.CFrame
	elseif instance:IsA("Attachment") then
        return instance.WorldCFrame
    end

    return nil, "Unable to get CFrame from Object!"
end


CFrameFromInstance.CheckAndGet = function(value)
	local success, message
		= CFrameFromInstance.Check(value)
	if success == false then
		return false, message
	end

	return CFrameFromInstance.Get(value)
end


return CFrameFromInstance