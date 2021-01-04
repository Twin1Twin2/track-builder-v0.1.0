-- simpler version of CreateSection
-- no optimization

local CFrameTrack = require(script.Parent.CFrameTrack)

local util = script.Parent.Util
local t = require(util.t)

local CheckArgs = t.tuple(
	CFrameTrack.IsType,	-- CFrameTrack
	t.number,			-- startPosition
	t.number,			-- endPosition
	t.number,			-- startOffset
	t.numberPositive,	-- segmentLength
	t.number,			-- segmentOffset
	t.boolean,			-- buildEnd
	t.callback			-- buildSegment
)

return function
(
	cframeTrack,
	startPosition,
	endPosition,
	startOffset,
	segmentLength,
	segmentOffset,
	buildEnd,
	buildSegment
)
	assert(CheckArgs(
		cframeTrack,
		startPosition,
		endPosition,
		startOffset,
		segmentLength,
		segmentOffset,
		buildEnd,
		buildSegment
	))

	assert(segmentOffset > -segmentLength,
		"SegmentOffset must be greater than SegmentLength")

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

	local index = 1

	local function BuildSegment(startTrackPosition, endTrackPosition)
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
	end

	while currentPosition < totalLength do
		local endTrackPosition = currentPosition + segmentLength

		if endTrackPosition > totalLength then
			break
		end

		BuildSegment(currentPosition, endTrackPosition)

		currentPosition = endTrackPosition + segmentOffset
	end

	-- build last (to end)
	if currentPosition < totalLength then
		BuildSegment(currentPosition, totalLength)
	end

	-- build end
	if buildEnd == true then
		BuildSegment(totalLength, totalLength + segmentLength)
	end
end