--- PointToPointCFrameTrack2
-- Allows for differently spaced points

local root = script.Parent
local CFrameTrack = require(root.CFrameTrack)
local TrackDataHasher = require(root.TrackDataHasher)

local util = script.Parent.Parent.Util
local CFrameFromInstance = require(util.CFrameFromInstance)

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


function PointToPointCFrameTrack2.fromData(data)
    assert(type(data) == "table")

    local self = PointToPointCFrameTrack2.new()
    self:SetData(data)

    return self
end


--- Creates a new PointToPointCFrameTrack2, but using instance data
--
function PointToPointCFrameTrack2.fromInstance(instanceData)
    assert(typeof(instanceData) == "Instance",
        "Arg [1] is not an Instance!")

    -- module script
    local data

    if instanceData:IsA("ModuleScript") == true then
        data = PointToPointCFrameTrack2.GetDataFromModuleScript(instanceData)
    else    -- model
        data = PointToPointCFrameTrack2.GetDataFromModel(instanceData)
    end

    return PointToPointCFrameTrack2.fromData(data)
end


function PointToPointCFrameTrack2.GetDataFromModel(instance)
    assert(typeof(instance) == "Instance",
        "Arg [1] is not an Instance")

    local pointsData = instance:FindFirstChild("Points")
    local isCircuitedValue = instance:FindFirstChild("IsCircuited")
    local hashIntervalValue = instance:FindFirstChild("HashInterval")

    assert(pointsData,
        "Missing Points! An Instance!")
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

    local hashInterval = 10

    if hashIntervalValue ~= nil then
        assert(hashIntervalValue:IsA("ValueBase"),
            "Missing HashInterval! A NumberValue")
        hashInterval = hashIntervalValue.Value
        assert(type(hashInterval) == "number" and hashInterval > 0,
            "HashInterval is not a number > 0!")
    end

    local data = {
        Points = points;
        IsCircuited = isCircuitedValue.Value;
        HashInterval = hashInterval;
    }

    return data
end


function PointToPointCFrameTrack2.GetDataFromModuleScript(moduleScript)
    assert(typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript"),
        "Arg [1] is not a ModuleScript!")

    local data = require(moduleScript)
    assert(type(data) == "table",
        "ModuleScript did not return a table!")

    local points = data.Points
    local isCircuited = data.IsCircuited
    local hashInterval = data.HashInterval

    assert(type(points) == "table",
        "Missing Points! A table")
    assert(type(isCircuited) == "boolean",
        "Missing IsCircuited! A boolean")
    assert(type(hashInterval) == "number" and hashInterval > 0,
        "Missing HashInterval! A number > 0")

    for index, point in pairs(points) do
        assert(typeof(point) == "CFrame",
            "Point " .. tostring(index) .. " is not a CFrame!")
    end

    return data
end


function PointToPointCFrameTrack2:Destroy()
    self.Hasher:Destroy()

    CFrameTrack.Destroy(self)

    setmetatable(self, nil)
end


function PointToPointCFrameTrack2:SetData(data)
    assert(type(data) == "table",
        "Arg [1] is not a table!")

    local points = data.Points
    local isCircuited = data.IsCircuited
    local hashInterval = data.HashInterval

    assert(type(points) == "table",
        "Missing Points! A table")
    assert(type(isCircuited) == "boolean",
        "Missing IsCircuited! A boolean")
    assert(type(hashInterval) == "number" and hashInterval > 0,
        "Missing HashInterval! A number > 0")

    for index, point in pairs(points) do
        assert(typeof(point) == "CFrame",
            "Point " .. tostring(index) .. " is not a CFrame!")
    end

    local function getLengthFunction(p1, p2)
        return (p1.Position - p2.Position).Magnitude
    end

    local hasher = TrackDataHasher.new(
        points,
        getLengthFunction,
        hashInterval
    )

    local length = hasher.Length
    local circuitRemainder = 0
    local lengthWithoutCircuitRemainder = length

    if isCircuited == true then
        circuitRemainder = getLengthFunction(
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