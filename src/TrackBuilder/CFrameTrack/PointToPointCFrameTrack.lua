--- PointToPointCFrameTrack
--

local root = script.Parent
local CFrameTrack = require(root.CFrameTrack)
local PointsUtil = require(root.PointsUtil)

local util = script.Parent.Parent.Util
local t = require(util.t)

local PointToPointCFrameTrack = {
    ClassName = "PointToPointCFrameTrack";
}

PointToPointCFrameTrack.__index = PointToPointCFrameTrack
setmetatable(PointToPointCFrameTrack, CFrameTrack)


function PointToPointCFrameTrack.new()
    local self = setmetatable(CFrameTrack.new(), PointToPointCFrameTrack)

    self.Points = {}

    self.DistanceBetweenPoints = 1

    self.IsCircuited = false
    self.CircuitRemainder = 0
    self.LengthWithoutCircuitRemainder = 0


    return self
end


local IsData = t.interface({
    Name = t.optional(t.string),

    Points = PointsUtil.IsType,

    DistanceBetweenPoints = t.numberPositive,
    IsCircuited = t.boolean,
})

function PointToPointCFrameTrack.fromData(data)
    assert(IsData(data))

    local self = PointToPointCFrameTrack.new()

    local points = data.Points
    local distanceBetweenPoints = data.DistanceBetweenPoints
    local isCircuited = data.IsCircuited

    if isCircuited == nil then
        isCircuited = self.IsCircuited
    end

    local numPoints = #points
    local length = ((numPoints - 1) * distanceBetweenPoints)
    local lengthWithoutCircuitRemainder = length
    local circuitRemainder = 0

    if isCircuited == true then
        circuitRemainder = (points[numPoints].Position - points[1].Position).Magnitude
        length = length + circuitRemainder
    end

    self.Points = points
    self.DistanceBetweenPoints = distanceBetweenPoints
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

        DistanceBetweenPoints = t.instanceIsA("NumberValue"),
        IsCircuited = t.instanceOf("BoolValue")
    })
)

--- Creates a new PointToPointCFrameTrack, but using instance data
--
function PointToPointCFrameTrack.fromInstance(instance)
    assert(IsInstance(instance))

    local data

    -- module script
    if instance:IsA("ModuleScript") == true then
        data = PointToPointCFrameTrack.GetDataFromModuleScript(instance)
    else    -- model
        data = PointToPointCFrameTrack.GetDataFromInstance(instance)
    end


    return PointToPointCFrameTrack.fromData(data)
end


function PointToPointCFrameTrack.GetDataFromInstance(instance)
    assert(t.Instance(instance))

    local pointsModel = instance:FindFirstChild("Points")
    local distanceBetweenPointsValue = instance:FindFirstChild("DistanceBetweenPoints")
    local isCircuitedValue = instance:FindFirstChild("IsCircuited")

    local points = PointsUtil.fromInstance(pointsModel)

    return {
        Name = instance.Name,

        Points = points,
        DistanceBetweenPoints = distanceBetweenPointsValue.Value,
        IsCircuited = isCircuitedValue.Value,
    }
end


function PointToPointCFrameTrack.GetDataFromModuleScript(moduleScript)
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


function PointToPointCFrameTrack:Destroy()
    self.Points = nil

    CFrameTrack.Destroy(self)

    setmetatable(self, nil)
end


function PointToPointCFrameTrack:GetCFramePosition(position)
    assert(t.number(position))

    local trackLength = self.Length
    local points = self.Points
    local numPoints = #points
    local isCircuited = self.IsCircuited

    if isCircuited == false then
        if position >= trackLength then
            local difference = position - trackLength
            local cf = points[numPoints]
            return cf * CFrame.new(0, 0, -difference)
        elseif position <= 0 then
            local cf = points[1]
            return cf * CFrame.new(0, 0, -position)
        end
    end

    local circuitRemainder = self.CircuitRemainder
    local lengthWithoutCircuitRemainder = self.LengthWithoutCircuitRemainder

    local p1, p2
    local lerpValue

    position = position % trackLength

    if isCircuited == true and position >= lengthWithoutCircuitRemainder then
        if circuitRemainder == 0 then
            return points[numPoints]
        else
            p1 = points[numPoints]
            p2 = points[1]
            lerpValue = (position - lengthWithoutCircuitRemainder) / circuitRemainder
        end
    else
        local distanceBetweenPoints = self.DistanceBetweenPoints
        local pIndex = math.floor(position / distanceBetweenPoints) + 1
        p1 = points[pIndex]
        p2 = points[pIndex + 1]
        lerpValue = (position % distanceBetweenPoints) / distanceBetweenPoints
    end

    return p1:Lerp(p2, lerpValue)
end


return PointToPointCFrameTrack