
local Draw3DTriangle = require(script.Parent.Draw3DTriangle)

local function Draw3DRect(startPosition1, startPosition2, endPosition1, endPosition2, wedge, parent)
	Draw3DTriangle(
		startPosition1,
		startPosition2,
		endPosition1,
		wedge,
		parent
	)
	Draw3DTriangle(
		endPosition1,
		endPosition2,
		startPosition2,
		wedge,
		parent
	)
end


return Draw3DRect