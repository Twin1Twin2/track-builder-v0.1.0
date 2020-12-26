--- port the get z rotation function from NewSmooth converters
-- Credit to whoever made the original NewSmooth converts (NWSpacek?)
--

local ROTATION_REPS = 128

-- CFrame
-- Vector3
-- CFrame
-- Vector3
-- Vector3
-- boolean
-- table
local function NewSmooth(previousPointCFrame, previousOffset, currentPointCFrame, currentOffset, partSize, partRotation, horizontal, meshData)
    assert(typeof(previousPointCFrame) == "CFrame",
        "Arg [1] is not a CFrame!")
    assert(typeof(previousOffset) == "Vector3",
        "Arg [2] is not a Vector3!")
    assert(typeof(currentPointCFrame) == "CFrame",
        "Arg [3] is not a CFrame!")
    assert(typeof(currentOffset) == "Vector3",
        "Arg [4] is not a Vector3!")
    assert(typeof(partSize) == "Vector3",
        "Arg [5] is not a Vector3!")
    assert(typeof(partRotation) == "Vector3",
        "Arg [6] is not a Vector3!")

    local previousCFrame = previousPointCFrame * CFrame.new(previousOffset)
    local currentCFrame = currentPointCFrame * CFrame.new(currentOffset)

    local rotPrevious = previousOffset + Vector3.new(0,3,0)
    local rotCurrent = currentOffset + Vector3.new(0,3,0)
    local standardCFrame = CFrame.new(
        (currentPointCFrame * CFrame.new(rotCurrent).Position)
            :Lerp((previousPointCFrame * CFrame.new(rotPrevious).Position), 0.5),
        (currentPointCFrame * CFrame.new(rotCurrent).Position)
    )

    local difference = (currentOffset + previousOffset) / 2 - (rotCurrent + rotPrevious) / 2
    local testCFrame = CFrame.new(currentCFrame.Position:Lerp(previousCFrame.Position, 0.5), currentCFrame.Position)
    local distance = ((testCFrame * CFrame.new(-difference)).Position - standardCFrame.Position).Magnitude
    local rotation = 0
    for i = 1, ROTATION_REPS do
        testCFrame = testCFrame*CFrame.Angles(0,0,2 * math.pi/ROTATION_REPS)
        local testDif = ((testCFrame * CFrame.new(-difference)).Position - standardCFrame.Position).Magnitude
        if testDif < distance then
            distance = testDif
            rotation = i
        end
    end

    local size
    local cframe
    local mesh

    partSize = Vector3.new(partSize.X, partSize.Y, 0)   -- force z = 0

    if horizontal then
        size = Vector3.new(partSize.X, 0, partSize.Y)
            + Vector3.new(0, (currentCFrame.Position - previousCFrame.Position).Magnitude + partSize.Z, 0)

        cframe = CFrame.new(currentCFrame.Position:Lerp(previousCFrame.Position, 0.5), currentCFrame.Position)
            * CFrame.Angles(0, 0, rotation * 2 * math.pi / ROTATION_REPS)
            * CFrame.Angles(-math.pi / 2, 0, 0)
            * CFrame.Angles(partRotation.X, partRotation.Y, partRotation.Z)
    else
        size = partSize
            + Vector3.new(0,0,(currentCFrame.Position - previousCFrame.Position).Magnitude)

        cframe = CFrame.new(currentCFrame.Position:Lerp(previousCFrame.Position, 0.5), currentCFrame.Position)
            * CFrame.Angles(0, 0, rotation * 2 * math.pi / ROTATION_REPS)
            * CFrame.Angles(partRotation.X, partRotation.Y, partRotation.Z)
    end

    if meshData then
        local meshType = meshData.Mesh
        local meshOffset = meshData.Offset
        local meshScale = meshData.Scale

        mesh = Instance.new(meshType)
        mesh.Offset = meshOffset

        if meshType == "SpecialMesh" then
            mesh.MeshType = meshData.MeshType
        end
        if horizontal then
            mesh.Offset = Vector3.new(meshOffset.X, meshOffset.Z, meshOffset.Y)
            mesh.Scale = Vector3.new(meshScale.X,(meshScale.Z + size.Y) / size.Y, meshScale.y)
        else
            mesh.Offset = meshOffset
            mesh.Scale = Vector3.new(meshScale.X, meshScale.y, (meshScale.Z + size.Z) / size.Z)
        end
    end

    return cframe, size, mesh
end

return NewSmooth