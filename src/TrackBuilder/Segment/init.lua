--- Segment Module

local util = script.Parent.Util
local t = require(util.t)

local Segment = {}

Segment.Segment = require(script.Segment)
Segment.IsType = Segment.Segment.IsType

Segment.MeshData = require(script.MeshData)

Segment.Rail = require(script.RailSegment)
Segment.RailBuilder = require(script.RailSegmentBuilder)

Segment.TrackObject = require(script.TrackObjectSegment)
Segment.TrackObjectBuilder = require(script.TrackObjectSegmentBuilder)

Segment.MidTrackObject = require(script.MidTrackObjectSegment)
Segment.MidTrackObjectBuilder = require(script.MidTrackObjectSegmentBuilder)

Segment.Crossbeam = require(script.CrossbeamSegment)
Segment.CrossbeamBuilder = require(script.CrossbeamSegment)

Segment.Rect = require(script.RectSegment)
Segment.RectBuilder = require(script.RectSegmentBuilder)

Segment.RectRail = require(script.RectRailSegment)
Segment.RectRailBuilder = require(script.RectRailSegmentBuilder)

Segment.BoxRail = require(script.BoxRailSegment)
Segment.BoxRailBuilder = require(script.BoxRailSegmentBuilder)


local SEGMENTS = {
	Rail = Segment.Rail,
    TrackObject = Segment.TrackObject,
	MidTrackObject = Segment.MidTrackObject,
	Crossbeam = Segment.Crossbeam,
	Rect = Segment.Rect,
	RectRail = Segment.RectRail,
	BoxRail = Segment.BoxRail,
}

Segment.CreateFromData = function(data, name)
    assert(type(data) == "table",
        "Arg [1] is not an table!")

    local className = data.SegmentType
    assert(type(className) == "string",
        "Missing TrackClass! A string!")

    local segmentClass = SEGMENTS[className]
    assert(segmentClass,
        ("Could not find TrackClass with name %s!"):format(className))

    local newTrack = segmentClass.new(data)

    newTrack.Name = name or data.Name


    return newTrack
end

Segment.IsInstanceData = t.children({
    SegmentType = t.instanceOf("StringValue")
})

Segment.CheckInstance = function(instance)
    local instanceDataSuccess, instanceDataMessage =
        Segment.IsInstanceData(instance)
    if instanceDataSuccess == false then
        return false, instanceDataMessage
    end

    local typeValue = instance:FindFirstChild("SegmentType")
    local className = typeValue.Value
    local segmentClass = SEGMENTS[className]

    if segmentClass == nil then
        return false, ("Could not find Segment with name %s!"):format(className)
    end

    return segmentClass.IsInstanceData(instance)
end

Segment.CreateFromInstance = function(instance)
    assert(Segment.CheckInstance(instance))

    local typeValue = instance:FindFirstChild("SegmentType")
    local className = typeValue.Value
    local segmentClass = SEGMENTS[className]

    return segmentClass.fromInstance(instance)
end

Segment.Create = function(data)
    if typeof(data) == "Instance" then
        return Segment.CreateFromInstance(data)
    elseif type(data) == "table" then
        return Segment.CreateFromData(data)
    else
        error("Unable to Create Segment! Invalid data!")
    end
end


return Segment