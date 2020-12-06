--- Hashes a track data table based on the track length between data
-- HashInterval is the lengths
--


local TrackDataHasher = {
    ClassName = "TrackDataHasher";
}

TrackDataHasher.__index = TrackDataHasher


--- Creates a new TrackDataHasher
-- @treturn TrackDataHasher
function TrackDataHasher.new(trackData, getLengthFunction, hashInterval)
    local self = setmetatable({}, TrackDataHasher)

    self.TrackData = {}

    self.HashInterval = 10
    self.HashData = {}

    self.Length = 0

    self:SetData(trackData, getLengthFunction, hashInterval)


    return self
end


function TrackDataHasher:Destroy()
    self.TrackData = nil
    self.HashData = nil

    setmetatable(self, nil)
end


function TrackDataHasher:SetData(trackData, getLengthFunction, hashInterval)
    assert(type(trackData) == "table")
    assert(type(getLengthFunction) == "function")

    hashInterval = hashInterval or self.HashInterval
    assert(type(hashInterval) == "number")

    local hashData = {}
    local currentLength = 0

    local function AddHashData(dataIndex)
        local data = {
            [1] = dataIndex,
            [2] = currentLength
        }

        table.insert(hashData, data)
    end

    local currentHashLength = 0
    local previousData = trackData[1]
    local previousDataIndex = 1

    AddHashData(previousDataIndex)

    for currentDataIndex = 2, #trackData, 1 do
        local currentData = trackData[currentDataIndex]
        local length = getLengthFunction(previousData, currentData)

        currentHashLength = currentHashLength + length

        if currentHashLength >= hashInterval then
            repeat
                AddHashData(previousDataIndex)
                currentHashLength = currentHashLength - hashInterval
            until currentHashLength < hashInterval
        end

        currentLength = currentLength + length
        previousData = currentData
        previousDataIndex = currentDataIndex
    end

    self.TrackData = trackData
    self.Length = currentLength
    self.HashData = hashData
    self.HashInterval = hashInterval
    self.GetLengthFunction = getLengthFunction
end


---
-- @tparam number position
-- @treturn T Data 1
-- @treturn T Data 2
-- @treturn number
function TrackDataHasher:GetData(position)
    local trackLength = self.Length

    local trackData = self.TrackData
    local numData = #trackData

    local d1, d2
    local difference

    if position >= trackLength then
        d1 = trackData[numData]
        difference = position - trackLength
    elseif position <= 0 then
        d2 = trackData[1]
        difference = position
    else
        local hashInterval = self.HashInterval
        local hashIndex = math.floor(position / hashInterval) + 1
        local hashData = self.HashData[hashIndex]

        local dIndex = hashData[1]
        local currentLength = hashData[2]

        local getLengthFunction = self.GetLengthFunction

        -- find data 1 and data 2
        d1 = trackData[dIndex]

        for index = (dIndex + 1), numData, 1 do
            d2 = trackData[index]
            local magnitude = getLengthFunction(d1, d2)
            local nextLength = currentLength + magnitude

            if currentLength <= position and position <= nextLength then
                difference = position - currentLength
                break
            end

            d1 = d2
            currentLength = nextLength
        end
    end

    return d1, d2, difference
end


return TrackDataHasher