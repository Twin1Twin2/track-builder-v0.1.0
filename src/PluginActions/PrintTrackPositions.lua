
local Selection = game:GetService("Selection")

local function GetCFrameFromInstance(instance)
    if instance:IsA("ObjectValue") then
        if instance.Value == nil then
            return nil, "ObjectValue.Value is nil! " .. instance:GetFullName()
        end
		instance = instance.Value
	end

    if instance:IsA("CFrameValue") then
        return instance.Value
    elseif instance:IsA("Vector3Value") then
        return CFrame.new(instance.Value)
    elseif instance:IsA("BasePart") then
        return instance.CFrame
	elseif instance:IsA("Attachment") then
        return instance.WorldCFrame
    end

    return nil, "Unable to get CFrame from Object! " .. instance:GetFullName()
end

local function PrintTrackPosition(trackPoint)
    if typeof(trackPoint) ~= "Instance" then
        return "Not an Instance!"
    end

    local trackPoints = trackPoint.Parent
    local trackPointIndex = tonumber(trackPoint.Name)

    if trackPointIndex == nil then
        return "Invalid point! Unable to get point index! Name = " .. trackPoint.Name
    end

    local trackPosition = 0
    local previousCFrame

    for index = 1, trackPointIndex, 1 do
        local point = trackPoints:FindFirstChild(tostring(index))
        local currentCFrame, message
            = GetCFrameFromInstance(point)

        if currentCFrame == nil then
            return "Missing points! Unable to get point " .. tostring(index) .. "! " .. tostring(message)
        end

        if previousCFrame ~= nil then
            trackPosition = trackPosition + (previousCFrame.Position - currentCFrame.Position).Magnitude
        end

        previousCFrame = currentCFrame
    end

    return tostring(trackPosition)
end


local function PrintTrackPositions()
    local selections = Selection:Get()

    if #selections == 0 then
        warn("PrintTrackPositions - Nothing selected!")
        return
    end

    warn("PrintTrackPositions:")
	for i, selection in ipairs(selections) do
		local result = PrintTrackPosition(selection)
        warn(("    [%d] = %s"):format(
            i,
            result
        ))
	end
end


return PrintTrackPositions