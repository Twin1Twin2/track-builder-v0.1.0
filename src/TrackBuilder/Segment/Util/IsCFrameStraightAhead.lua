
local MINIMUM_ZERO_ANGLE = 0.99995

local function IsCFrameStraightAhead(cf1, cf2)
	local lvDot = cf1.LookVector:Dot(cf2.LookVector)
	local posDot = cf1.LookVector:Dot((cf2.Position - cf1.Position).Unit)
	local rotDot = cf1.RightVector:Dot(cf2.RightVector)

	return lvDot > MINIMUM_ZERO_ANGLE
		and posDot > MINIMUM_ZERO_ANGLE
		and rotDot > MINIMUM_ZERO_ANGLE
end


return IsCFrameStraightAhead