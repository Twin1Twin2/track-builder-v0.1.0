--- PointsUtil
--

local util = script.Parent.Parent.Util
local t = require(util.t)
local CFrameInstance = require(util.CFrameInstance)

local IsType = function(object)
    local arraySuccess, arrayMessage
        = t.array(t.CFrame)(object)

    if arraySuccess == false then
        return false, arrayMessage
    end

    if #object == 0 then
        return false, "points cannot be empty"
    end

    return true
end

local IsInstanceData = function(instance)
    local instanceSuccess, instanceMessage
        = t.Instance(instance)
    if instanceSuccess == false then
        return false, instanceMessage
    end

    local missingPoints = {}
    local isMissingPoints = false

    for index = 1, #instance:GetChildren(), 1 do
        local point = instance:FindFirstChild(tostring(index))
		local cframe, message = CFrameInstance.CheckAndGet(point)

        if cframe == false then
            missingPoints[index] = message
            isMissingPoints = true
        end
    end

    if isMissingPoints == true then
        local errorMessage = ""

        for i, message in ipairs(missingPoints) do
            errorMessage = errorMessage .. "\n    " .. tostring(i) .. " " .. message
        end

        return false, ("missing points:%s"):format(
            errorMessage
        )
	end

	return true
end

local function fromInstance(instance)
	assert(t.Instance(instance))

	local points = {}

    for index = 1, #instance:GetChildren(), 1 do
        local point = instance:FindFirstChild(tostring(index))
        local cframe, message = CFrameInstance.CheckAndGet(point)

        if cframe == false then
            assert(false,
                "[" ..  tostring(index) .. "]: " .. message or "")
        end

        table.insert(points, index, cframe)
    end

	return points
end


return {
    IsType = IsType,
    IsInstanceData = IsInstanceData,

    fromInstance = fromInstance
}