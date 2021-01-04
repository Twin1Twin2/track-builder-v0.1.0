
local CFrameTrack = {}

local PointsUtil = require(script.PointsUtil)
CFrameTrack.IsPoints = PointsUtil.IsType
CFrameTrack.GetPointsFromInstance = PointsUtil.fromInstance

CFrameTrack.CFrameTrack = require(script.CFrameTrack)
CFrameTrack.IsType = CFrameTrack.CFrameTrack.IsType

CFrameTrack.PointToPoint = require(script.PointToPointCFrameTrack)
CFrameTrack.PointToPointBuilder = require(script.PointToPointCFrameTrackBuilder)

CFrameTrack.PointToPoint2 = require(script.PointToPointCFrameTrack2)
CFrameTrack.PointToPoint2Builder = require(script.PointToPointCFrameTrack2Builder)


local TRACKS = {
    PointToPoint = CFrameTrack.PointToPoint;
    PointToPoint2 = CFrameTrack.PointToPoint2;
}

local function CreateFromData(data, name)
    assert(type(data) == "table",
        "Arg [1] is not an table!")

    local trackClassName = data.TrackClass
    assert(type(trackClassName) == "string",
        "Missing TrackClass! A string!")

    local trackClass = TRACKS[trackClassName]
    assert(trackClass,
        ("Could not find TrackClass with name %s!"):format(trackClassName))

    local newTrack = trackClass.fromData(data)

    newTrack.Name = name or data.Name


    return newTrack
end

local function CreateFromInstance(instanceData, name)
    assert(typeof(instanceData) == "Instance",
        "Arg [1] is not an Instance!")

    local typeValue = instanceData:FindFirstChild("TrackClass")
    assert(typeValue and typeValue:IsA("StringValue"),
        "Missing TrackClass! A StringValue!")

    local trackClassName = typeValue.Value
    local trackClass = TRACKS[trackClassName]
    assert(trackClass,
        ("Could not find TrackClass with name %s!"):format(trackClassName))

    local newTrack = trackClass.fromInstance(instanceData)

    newTrack.Name = name or instanceData.Name

    return newTrack
end

CFrameTrack.Create = function(data)
    if typeof(data) == "Instance" then
        return CreateFromInstance(data)
    elseif type(data) == "table" then
        return CreateFromData(data)
    else
        error("Unable to Create Track! Invalid data!")
    end
end

CFrameTrack.CreateFromData = CreateFromData
CFrameTrack.CreateFromInstance = CreateFromInstance



return CFrameTrack