--- PluginManager
--- Manages the OOP state for the plugin

local Selection = game:GetService("Selection")

local root = script.Parent
local Actions = require(root.Actions)

local PluginActions = require(root.PluginActions)
local ProgramActions = PluginActions.ProgramActions

local TrackBuilder = require(root.TrackBuilder)
local CFrameTrack = TrackBuilder.CFrameTrack
local TrackGroup = TrackBuilder.TrackGroup

local util = root.Util
local t = require(util.t)
local WrapXpcall = require(util.WrapXpcall)


local function LoadSelected(func)
	local selections = Selection:Get()
	if #selections == 0 then
		warn("Nothing Selected!")
		return
	end

	local selection = selections[1]
	func(selection)
end


local PluginManager = {
	ClassName = "PluginManager";
}

PluginManager.__index = PluginManager


function PluginManager.new()
	local self = setmetatable({}, PluginManager)

	self.Store = nil

	self.CurrentTrack = nil
	self.LoadedTracks = {}

	self.CurrentTrackGroup = nil

	self.StartPosition = 0
	self.EndPosition = 0


	return self
end


function PluginManager:Destroy()
	self.Store = nil

	if self.CurrentTrack then
		self.CurrentTrack:Destroy()
	end

	if self.CurrentTrackGroup then
		self.CurrentTrackGroup:Destroy()
	end

	self.LoadedTracks = nil
end


function PluginManager:InitStore(store)
    self.Store = store

    self.Store:dispatch(Actions.SetCurrentTrack(nil))
	-- self.Store:dispatch(Actions.SetLoadedTracks({}))

	self.Store:dispatch(Actions.SetCurrentTrackGroup(nil))

	self.Store:dispatch(Actions.SetStartPosition(self.StartPosition))
	self.Store:dispatch(Actions.SetEndPosition(self.EndPosition))
end


function PluginManager:SetTrack(cframeTrack)
	self.CurrentTrack = cframeTrack
    self.Store:dispatch(Actions.SetCurrentTrack(cframeTrack and cframeTrack.Name or nil, ""))
end


local XpcallCFrameTrackFromInstance = WrapXpcall(CFrameTrack.CreateFromInstance)

function PluginManager:LoadTrack(instance)
	assert(t.Instance(instance))

	local success, track = XpcallCFrameTrackFromInstance(instance)
	if success == false then
		warn(track)
		return
	end

	self:SetTrack(track)
end


function PluginManager:LoadSelectedTrack()
	LoadSelected(function(selection)
		self:LoadTrack(selection)
	end)
end


function PluginManager:SetTrackGroup(trackGroup)
	self.CurrentTrackGroup = trackGroup
    self.Store:dispatch(Actions.SetCurrentTrackGroup(trackGroup and trackGroup.Name or nil, ""))
end

local XpcallTrackGroupFromData = WrapXpcall(TrackGroup.fromData)

local function LoadTrackGroupFromModule(moduleScript)
	local loadSuccess, program = ProgramActions.LoadProgram(moduleScript)
	if loadSuccess == false then
		return false, program
	end

	if type(program) == "function" then
		return ProgramActions.RunProgram(program)
	elseif type(program) == "table" then
		return XpcallTrackGroupFromData(program)
	else
		return false, "Module returned invalid type"
	end
end


local XpcallTrackGroupFromInstance = WrapXpcall(TrackGroup.fromInstance)

local function LoadTrackGroupFromInstance(instance)
	return XpcallTrackGroupFromInstance(instance)
end


function PluginManager:LoadTrackGroup(instance)
	assert(t.tuple(t.Instance(instance)))

	local success, trackGroup

	if instance:IsA("ModuleScript") then
		success, trackGroup = LoadTrackGroupFromModule(instance)
	else
		success, trackGroup = LoadTrackGroupFromInstance(instance)
	end

	if success == false then
		warn(trackGroup)
		return
	end

	self:SetTrackGroup(trackGroup)
end


function PluginManager:LoadSelectedTrackGroup()
	LoadSelected(function(selection)
		self:LoadTrackGroup(selection)
	end)
end


function PluginManager:SetStartPosition(position)
	assert(t.tuple(t.number(position)))

	self.StartPosition = position
	self.Store:dispatch(Actions.SetStartPosition(self.StartPosition))
end


function PluginManager:SetEndPosition(position)
	assert(t.tuple(t.number(position)))

	self.EndPosition = position
	self.Store:dispatch(Actions.SetEndPosition(self.EndPosition))
end


function PluginManager:SetEndPositionAsTrackEnd(position)
	assert(t.tuple(t.number(position)))

	if self.CurrentTrack == nil then
		return
	end

	self.EndPosition = self.CurrentTrack.Length
	self.Store:dispatch(Actions.SetEndPosition(self.EndPosition))
end


function PluginManager:_Build(cframeTrack, trackGroup, startPosition, endPosition)
	if cframeTrack == nil then
		return false, "Track not set!"
	end

	if trackGroup == nil then
		return false, "TrackGroup not set!"
	end

	if startPosition == endPosition then
		return false, "Start cannot equal End Position!"
	end

	if startPosition > endPosition then
		local constrainToTrack = t.numberConstrained(0, cframeTrack.Length)
		local startSuccess, startMessage =
			constrainToTrack(startPosition)
		if startSuccess == false then
			return false, startMessage
		end

		local endSuccess, endMessage =
			constrainToTrack(endPosition)
		if endSuccess == false then
			return false, endMessage
		end
	end

	local model = trackGroup:Create(
		cframeTrack,
		startPosition,
		endPosition
	)
	model.Parent = workspace

	return true
end


function PluginManager:Build()
	local cframeTrack = self.CurrentTrack
	local trackGroup = self.CurrentTrackGroup
	local startPosition = self.StartPosition
	local endPosition = self.EndPosition

	local success, message
		= self:_Build(cframeTrack, trackGroup, startPosition, endPosition)

	if success == false then
		warn(message)
	end
end


return PluginManager.new()