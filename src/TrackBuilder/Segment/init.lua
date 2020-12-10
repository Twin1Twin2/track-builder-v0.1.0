--- Segment Module

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
	Tie = Segment.Tie,
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

Segment.CreateFromInstance = function(instance)
    assert(typeof(instance) == "Instance",
        "Arg [1] is not an Instance!")

    local typeValue = instance:FindFirstChild("SegmentType")
    assert(typeValue and typeValue:IsA("StringValue"),
        "Missing TrackClass! A StringValue!")

    local className = typeValue.Value
    local segmentClass = SEGMENTS[className]
    assert(segmentClass,
        ("Could not find Segment with name %s!"):format(className))

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

-- Segment.IsInstanceData = function(data)

-- end


return Segment