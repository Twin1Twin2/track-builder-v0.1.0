
local PointToPointCFrameTrack = require(script.Parent.PointToPointCFrameTrack)
local PointsUtil = require(script.Parent.PointsUtil)

local root = script.Parent.Parent

local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local PointToPointCFrameTrackBuilder = {
	ClassName = "PointToPointCFrameTrackBuilder";
}

PointToPointCFrameTrackBuilder.__index = PointToPointCFrameTrackBuilder
setmetatable(PointToPointCFrameTrackBuilder, Builder)


function PointToPointCFrameTrackBuilder.new()
	local self = setmetatable(Builder.new(), PointToPointCFrameTrackBuilder)

	self.Points = nil

	self.DistanceBetweenPoints = nil
	self.IsCircuited = false


	return self
end


local BuilderCheck = Builder.Check({
	"Points",
	"DistanceBetweenPoints"
})


function PointToPointCFrameTrackBuilder:Build()
	assert(BuilderCheck(self))

	return PointToPointCFrameTrack.fromData({
		Name = self.Name,

		Points = self.Points,

		DistanceBetweenPoints = self.DistanceBetweenPoints,
		IsCircuited = self.IsCircuited,
	})
end


function PointToPointCFrameTrackBuilder:WithPoints(points)
	assert(PointsUtil.IsType(points))

	self.Points = points

	return self
end


function PointToPointCFrameTrackBuilder:WithPointsInstance(pointsInstance)
	local pointSuccess, pointsMessage
		= PointsUtil.IsInstanceData(pointsInstance)
	assert(pointSuccess, pointsMessage)

	local points = PointsUtil.fromInstance(pointsInstance)

	assert(points, pointsMessage)

	self.Points = points

	return self
end


function PointToPointCFrameTrackBuilder:WithDistanceBetweenPoints(distance)
	assert(t.numberPositive(distance))

	self.DistanceBetweenPoints = distance

	return self
end


function PointToPointCFrameTrackBuilder:WithIsCircuited(value)
	assert(t.boolean(value))

	self.IsCircuited = value

	return self
end


return PointToPointCFrameTrackBuilder