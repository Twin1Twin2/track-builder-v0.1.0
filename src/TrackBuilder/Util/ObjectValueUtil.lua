--- ObjectValueUtil
--

local t = require(script.Parent.t)

local function Reduce(value)
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

local function Type(check)
	assert(t.callback(check))

	return function(value)
		local reduceValue, reduceMessage
			= Reduce(value)

		if reduceValue == false then
			return false, reduceMessage
		end

		return check(reduceValue)
	end
end

return {
	Reduce = Reduce,
	Type = Type,
}