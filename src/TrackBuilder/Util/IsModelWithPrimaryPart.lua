
local t = require(script.Parent.t)

return function(value)
	local modelSuccess, modelMessage =
		t.instanceOf("Model")(value)
	if modelSuccess == false then
		return false, modelMessage
	end

	if value.PrimaryPart == nil then
		return false, "PrimaryPart not set! " .. value:GetFullName()
	end

	return true
end