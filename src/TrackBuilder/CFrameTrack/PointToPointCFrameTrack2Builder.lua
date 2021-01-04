
local PointToPointCFrameTrack2 = require(script.Parent.PointToPointCFrameTrack2)
local PointsUtil = require(script.Parent.PointsUtil)

local root = script.Parent.Parent

local Builder = require(root.Builder)

local util = root.Util
local t = require(util.t)


local PointToPointCFrameTrack2Builder = {
	ClassName = "PointToPointCFrameTrack2Builder";
}

PointToPointCFrameTrack2Builder.__index = PointToPointCFrameTrack2Builder
setmetatable(PointToPointCFrameTrack2Builder, Builder)


function PointToPointCFrameTrack2Builder.new()
	local self = setmetatable(Builder.new(), PointToPointCFrameTrack2Builder)

	self.Points = nil

	self.HashInterval = 10
	self.IsCircuited = false


	return self
end


local BuilderCheck = Builder.Check({
	"Points",
})


function PointToPointCFrameTrack2Builder:Build()
	assert(BuilderCheck(self))

	return PointToPointCFrameTrack2.fromData({
		Name = self.Name,

		Points = self.Points,
		HashInterval = self.HashInterval,
		IsCircuited = self.IsCircuited,
	})
end


function PointToPointCFrameTrack2Builder:WithPoints(points)
	assert(PointsUtil.IsType(points))

	self.Points = points

	return self
end


function PointToPointCFrameTrack2Builder:WithPointsInstance(pointsInstance)
	local pointSuccess, pointsMessage
		= PointsUtil.IsInstanceData(pointsInstance)
	assert(pointSuccess, pointsMessage)

	local points = PointsUtil.fromInstance(pointsInstance)


	self.Points = points

	return self
end


function PointToPointCFrameTrack2Builder:WithHashInterval(interval)
	assert(t.numberPositive(interval))

	self.HashInterval = interval

	return self
end


function PointToPointCFrameTrack2Builder:WithIsCircuited(value)
	assert(t.boolean(value))

	self.IsCircuited = value

	return self
end


return PointToPointCFrameTrack2Builder