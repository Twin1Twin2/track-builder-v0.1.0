-- reduce value if object value to it's value. returns false if value is not set

local t = require(script.Parent.t)

return function(value)
	local instanceSuccess, instanceErrMsg = t.Instance(value)
	if not instanceSuccess then
		return false, instanceErrMsg or ""
	end

	if value:IsA("ObjectValue") then
		if value.Value == nil then
			return false, "ObjectValue.Value not set! " .. value:GetFullName()
		end
		value = value.Value
	end

	return value
end