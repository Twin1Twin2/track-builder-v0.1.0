
local util = script.Parent.Parent.Util
local InstanceOfClass = require(util.InstanceOfClass)

local CFrameTrack = {
    ClassName = "CFrameTrack";
}

CFrameTrack.__index = CFrameTrack

CFrameTrack.IsType = InstanceOfClass(CFrameTrack)


function CFrameTrack.new(name)
    local self = setmetatable({}, CFrameTrack)

    self.Name = name or "DEFAULT_TRACK_NAME"
    self.Length = 0


    return self
end


function CFrameTrack.fromData()
    error("fromData not implemented!")
end


function CFrameTrack.fromInstance()
    error("fromInstance not implemented!")
end


function CFrameTrack:Destroy()
    setmetatable(self, nil)
end


function CFrameTrack:GetCFramePosition(_)
    return CFrame.new()
end


return CFrameTrack