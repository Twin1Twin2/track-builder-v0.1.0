--- CreateSection

local util = script.Parent.Util
local IsCFrameStraightAhead = require(util.IsCFrameStraightAhead)

return function
(	-- big block of args. don't feel like using a table
	cframeTrack,
	startPosition,
	endPosition,
	startOffset,
	interval,
	optimize,
	buildEnd,
	buildSegment
)

	local trackLength = cframeTrack.Length

	local totalLength
	if startPosition < endPosition then
		totalLength = endPosition - startPosition
	else
		totalLength = (trackLength - startPosition) + endPosition
	end

	local function GetTrackCFrame(trackPosition)
		local position = (startPosition + trackPosition) % trackLength
		return cframeTrack:GetCFramePosition(position)
	end

	local currentPosition = startOffset

	local function GetCurrentCFrame()
		return GetTrackCFrame(currentPosition)
	end

	local lastPosition = currentPosition
	local lastUsedPosition = currentPosition

	currentPosition = currentPosition + interval

	local index = 1

	local function Build(startTrackPosition, endTrackPosition)
		local startCFrame = GetTrackCFrame(startTrackPosition)
		local endCFrame = GetTrackCFrame(endTrackPosition)
		local midTrackPosition = (startTrackPosition + endTrackPosition) / 2

		buildSegment(
			startCFrame,
			endCFrame,
			index,
			midTrackPosition,
			totalLength
		)

		index = index + 1
		lastUsedPosition = endTrackPosition
	end

	local function BuildOptimized()
		local currentCFrame = GetCurrentCFrame()
		local lastUsedCFrame = GetTrackCFrame(lastUsedPosition)

		local isStraightAhead = IsCFrameStraightAhead(lastUsedCFrame, currentCFrame)

		if isStraightAhead == false then
			Build(lastUsedPosition, lastPosition)
		end

		lastPosition = currentPosition
	end

	local function BuildUnoptimized()
		Build(lastUsedPosition, currentPosition)
	end

	local buildFunction
	if optimize == true then
		buildFunction = BuildOptimized
	else
		buildFunction = BuildUnoptimized
	end

	while currentPosition < totalLength do
		buildFunction()

		currentPosition = currentPosition + interval
	end

	-- build last
	if optimize == true then
		local lastUsedCFrame = GetTrackCFrame(lastUsedPosition)
		local endCFrame = cframeTrack:GetCFramePosition(endPosition)

		if IsCFrameStraightAhead(lastUsedCFrame, endCFrame) then
			Build(lastUsedPosition, endPosition)
		else	-- build to previous, then finish it out
			Build(lastUsedPosition, lastPosition)
			Build(lastUsedPosition, endPosition)
		end
	else
		Build(lastUsedPosition, endPosition)
	end

	-- build end
	if buildEnd == true then
        Build(endPosition, endPosition + interval)
	end
end