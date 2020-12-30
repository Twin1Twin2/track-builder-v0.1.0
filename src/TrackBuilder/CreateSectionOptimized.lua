-- simpler version of CreateSection's Optimization
-- does not use segment offset

local CFrameTrack = require(script.Parent.CFrameTrack)

local util = script.Parent.Util
local t = require(util.t)

local CheckArgs = t.tuple(
	CFrameTrack.IsType,	-- CFrameTrack
	t.number,			-- startPosition
	t.number,			-- endPosition
	t.number,			-- startOffset
	t.numberPositive,	-- segmentLength
	t.callback,			-- checkIsStraightAhead
	t.boolean,			-- buildEnd
	t.callback			-- buildSegment
)

return function
(	-- big block of args. don't feel like using a table
	cframeTrack,
	startPosition,
	endPosition,
	startOffset,
	segmentLength,
	checkIsStraightAhead,
	buildEnd,
	buildSegment
)
	assert(CheckArgs(
		cframeTrack,
		startPosition,
		endPosition,
		startOffset,
		segmentLength,
		checkIsStraightAhead,
		buildEnd,
		buildSegment
	))

	local trackLength = cframeTrack.Length

	local totalLength
	if startPosition < endPosition then
		totalLength = endPosition - startPosition
	else
		totalLength = (trackLength - startPosition) + endPosition
	end

	local function GetTrackCFrame(trackPosition)
		local position = startPosition + trackPosition

		if trackPosition ~= trackLength then	-- trackLength can be used
			position = position % trackLength
		end

		return cframeTrack:GetCFramePosition(position)
	end

	local currentPosition = startOffset

	local function GetCurrentCFrame()
		return GetTrackCFrame(currentPosition)
	end

	local lastPosition = currentPosition
	local lastUsedPosition = currentPosition

	currentPosition = currentPosition + segmentLength

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

	while currentPosition < totalLength do
		local currentCFrame = GetCurrentCFrame()
		local lastUsedCFrame = GetTrackCFrame(lastUsedPosition)

		local isStraightAhead = checkIsStraightAhead(lastUsedCFrame, currentCFrame)

		if isStraightAhead == false then
			Build(lastUsedPosition, lastPosition)
		end

		lastPosition = currentPosition

		currentPosition = currentPosition + segmentLength
	end

	-- build last
	local lastUsedCFrame = GetTrackCFrame(lastUsedPosition)
	local endCFrame = cframeTrack:GetCFramePosition(endPosition)

	if checkIsStraightAhead(lastUsedCFrame, endCFrame) then
		Build(lastUsedPosition, totalLength)
	else	-- build to previous, then finish it out
		Build(lastUsedPosition, lastPosition)
		Build(lastUsedPosition, totalLength)
	end

	-- build end
	if buildEnd == true then
        Build(totalLength, totalLength + segmentLength)
	end
end