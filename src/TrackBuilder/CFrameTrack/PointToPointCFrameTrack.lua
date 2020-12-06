--- PointToPointCFrameTrack
--

local root = script.Parent
local CFrameTrack = require(root.CFrameTrack)

local util = script.Parent.Parent.Util
local CFrameFromInstance = require(util.CFrameFromInstance)


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


function PointToPointCFrameTrack.fromData(data)
    assert(type(data) == "table")

    local self = PointToPointCFrameTrack.new()
    self:SetData(data)

    return self
end


--- Creates a new PointToPointCFrameTrack, but using instance data
--
function PointToPointCFrameTrack.fromInstance(instanceData)
    assert(typeof(instanceData) == "Instance")

    local data

    -- module script
    if instanceData:IsA("ModuleScript") == true then
        data = PointToPointCFrameTrack.GetDataFromModuleScript(instanceData)
    else    -- model
        data = PointToPointCFrameTrack.GetDataFromModel(instanceData)
    end


    return PointToPointCFrameTrack.fromData(data)
end


function PointToPointCFrameTrack.GetDataFromModel(instance)
    assert(typeof(instance) == "Instance",
        "Arg [1] is not an Instance!")

    local pointsData = instance:FindFirstChild("Points")
    local distanceBetweenPointsValue = instance:FindFirstChild("DistanceBetweenPoints")
    local isCircuitedValue = instance:FindFirstChild("IsCircuited")

    assert(pointsData,
        "Missing Points! An Instance")
    assert(distanceBetweenPointsValue,
        "Missing DistanceBetweenPoints! A NumberValue")
    assert(isCircuitedValue and isCircuitedValue:IsA("BoolValue"),
        "Missing IsCircuited! A BoolValue")

    local points = {}
    local missingPoints = {}
    local isMissingPoints = false

    for index = 1, #pointsData:GetChildren(), 1 do
        local point = pointsData:FindFirstChild(tostring(index))
        local cframe, message = CFrameFromInstance.CheckAndGet(point)
        if cframe ~= nil then
            table.insert(points, index, cframe)
        else
            missingPoints[index] = message
            isMissingPoints = true
        end
    end

    if isMissingPoints then
        local errorMessage = ""

        for i, message in ipairs(missingPoints) do
            errorMessage = errorMessage .. "\n    " .. tostring(i) .. " " .. message
        end

        error(("Could not convert from InstanceData. Missing Points:%s"):format(
            errorMessage
        ))
    end

    local data = {
        Points = points;
        DistanceBetweenPoints = distanceBetweenPointsValue.Value;
        IsCircuited = isCircuitedValue.Value
    }


    return data
end


function PointToPointCFrameTrack.GetDataFromModuleScript(moduleScript)
    assert(typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript"))

    local data = require(moduleScript)
    assert(type(data) == "table",
        "Module did not return a table!")

    -- check for points
    -- check for distance between points
    -- check for isCircuited

    local points = data.Points
    local distanceBetweenPoints = data.DistanceBetweenPoints
    local isCircuited = data.IsCircuited

    assert(type(points) == "table",
        "Missing Points! A table of CFrames!")
    assert(type(distanceBetweenPoints) == "number" and distanceBetweenPoints > 0,
        "Missing DistanceBetweenPoints! A number > 0")
    assert(type(isCircuited) == "boolean",
        "Missing IsCircuited! A boolean")

    for index, point in ipairs(points) do
        assert(typeof(point) == "CFrame",
            "Point " .. tostring(index) .. " is not a CFrame!")
    end

    return data
end


function PointToPointCFrameTrack:Destroy()
    self.Points = nil

    CFrameTrack.Destroy(self)

    setmetatable(self, nil)
end


function PointToPointCFrameTrack:SetData(data)
    local points = data.Points
    local distanceBetweenPoints = data.DistanceBetweenPoints
    local isCircuited = data.IsCircuited

    assert(type(points) == "table",
        "Missing Points! A table of CFrames!")
    assert(type(distanceBetweenPoints) == "number" and distanceBetweenPoints > 0,
        "Missing DistanceBetweenPoints! A number > 0")

    if isCircuited == nil then
        isCircuited = self.IsCircuited
    end

    assert(type(isCircuited) == "boolean",
        "Missing IsCircuited! A boolean")

    local numPoints = #points
    local length = ((numPoints - 1) * distanceBetweenPoints)
    local lengthWithoutCircuitRemainder = length
    local circuitRemainder = 0

    assert(numPoints > 0,
        "Points is empty!")

    for index, point in pairs(points) do
        assert(typeof(point) == "CFrame",
            "Point " .. tostring(index) .. " is not a CFrame!")
    end

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


function PointToPointCFrameTrack:GetCFramePosition(position)
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