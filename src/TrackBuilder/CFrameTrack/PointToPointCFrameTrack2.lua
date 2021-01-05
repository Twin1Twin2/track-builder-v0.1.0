--- PointToPointCFrameTrack2
-- Allows for differently spaced points

local root = script.Parent
local CFrameTrack = require(root.CFrameTrack)
local TrackDataHasher = require(root.TrackDataHasher)
local PointsUtil = require(root.PointsUtil)

local util = script.Parent.Parent.Util
local t = require(util.t)

local function GetLengthFunction(p1, p2)
    return (p1.Position - p2.Position).Magnitude
end


local PointToPointCFrameTrack2 = {
    ClassName = "PointToPointCFrameTrack2";
}

PointToPointCFrameTrack2.__index = PointToPointCFrameTrack2
setmetatable(PointToPointCFrameTrack2, CFrameTrack)


function PointToPointCFrameTrack2.new()
    local self = setmetatable(CFrameTrack.new(), PointToPointCFrameTrack2)

    self.Hasher = nil

    self.IsCircuited = false
    self.CircuitRemainder = 0
    self.LengthWithoutCircuitRemainder = 0


    return self
end


local IsData = t.interface({
    Name = t.optional(t.string),

    Points = PointsUtil.IsType,

    HashInterval = t.optional(t.numberPositive),
    IsCircuited = t.boolean,
})

function PointToPointCFrameTrack2.fromData(data)
    assert(IsData(data))

    local self = PointToPointCFrameTrack2.new()

    local points = data.Points
    local isCircuited = data.IsCircuited
    local hashInterval = data.HashInterval

    local hasher = TrackDataHasher.create(
        points,
        GetLengthFunction,
        hashInterval
    )

    local length = hasher.Length
    local circuitRemainder = 0
    local lengthWithoutCircuitRemainder = length

    if isCircuited == true then
        circuitRemainder = GetLengthFunction(
            points[#points],
            points[1]
        )
        length = length + circuitRemainder
    end

    self.Hasher = hasher
    self.Length = length
    self.CircuitRemainder = circuitRemainder
    self.LengthWithoutCircuitRemainder = lengthWithoutCircuitRemainder
    self.IsCircuited = isCircuited


    return self
end


local IsInstance = t.union(
    t.instanceIsA("ModuleScript"),
    t.children({
        Points = PointsUtil.IsInstanceData,

        HashInterval = t.optional(t.instanceIsA("NumberValue")),
        IsCircuited = t.instanceOf("BoolValue")
    })
)

--- Creates a new PointToPointCFrameTrack2, but using instance data
--
function PointToPointCFrameTrack2.fromInstance(instance)
    assert(IsInstance(instance))

    -- module script
    local data

    if instance:IsA("ModuleScript") == true then
        data = PointToPointCFrameTrack2.GetDataFromModuleScript(instance)
    else    -- model
        data = PointToPointCFrameTrack2.GetDataFromInstance(instance)
    end

    return PointToPointCFrameTrack2.fromData(data)
end


function PointToPointCFrameTrack2.GetDataFromInstance(instance)
    assert(t.Instance(instance))

    local pointsModel = instance:FindFirstChild("Points")
    local hashIntervalValue = instance:FindFirstChild("HashInterval")
    local isCircuitedValue = instance:FindFirstChild("IsCircuited")

    local points = PointsUtil.fromInstance(pointsModel)

    local hashInterval = nil
    if hashIntervalValue then
        hashInterval = hashIntervalValue.Value
    end

    return {
        Name = instance.Name,

        Points = points,
        HashInterval = hashInterval,
        IsCircuited = isCircuitedValue.Value,
    }
end


function PointToPointCFrameTrack2.GetDataFromModuleScript(moduleScript)
    assert(t.instanceIsA("ModuleScript")(moduleScript))

    local data = require(moduleScript)
    assert(type(data) == "table",
        "Module did not return a table!")

    assert(IsData(data))

    if data.Name == nil then
        data.Name = moduleScript.Name
    end

    return data
end


function PointToPointCFrameTrack2:Destroy()
    self.Hasher:Destroy()

    CFrameTrack.Destroy(self)

    setmetatable(self, nil)
end


function PointToPointCFrameTrack2:GetCFramePosition(position)
    local hasher = self.Hasher
    local circuited = self.IsCircuited
    local lengthWithoutCircuitRemainder = self.LengthWithoutCircuitRemainder

    if circuited == true then -- clamp position to track length
        position = (position % self.Length)
    end

    if circuited == true and position >= lengthWithoutCircuitRemainder then
        local points = hasher.TrackData
        local p1 = points[#points]
        local p2 = points[1]
        local lerpValue = (position - lengthWithoutCircuitRemainder) / self.CircuitRemainder

        return p1:Lerp(p2, lerpValue)
    end

    local p1, p2, difference = hasher:GetData(position)

    if p1 == nil then -- position is <= 0
        return p2 * CFrame.new(0, 0, -difference)
    elseif p2 == nil then -- position is >= trackLength
        return p1 * CFrame.new(0, 0, -difference)
    else
        local lerpValue = 0
        local magnitude = hasher.GetLengthFunction(p1, p2)

        if magnitude ~= 0 then
            lerpValue = difference / hasher.GetLengthFunction(p1, p2)
        end

        return p1:Lerp(p2, lerpValue)
    end
end


return PointToPointCFrameTrack2