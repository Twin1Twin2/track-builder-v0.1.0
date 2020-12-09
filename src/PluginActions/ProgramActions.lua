
local Selection = game:GetService("Selection")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local root = script.Parent.Parent

local TrackBuilder = require(root.TrackBuilder)

local util = root.Util
local Table = require(util.Table)

local api = Table.Copy(TrackBuilder)

local apiEnv = setmetatable({}, {
    __index = function(_, key)
        return api[key]
    end;

    __newindex = function(_, _, _)
        error("Cannot write to Custom API")
    end;

    __metatable = {};
})


local function handleError(message)
	return debug.traceback(tostring(message), 2)
end


local function LoadProgram(moduleScript)
	local clonedModule = moduleScript:Clone()   -- to allow reloading
	clonedModule.Parent = moduleScript.Parent   -- keep the same workspace env

	local requireSuccess, requireMessage = xpcall(
		require,
		handleError,
		clonedModule
	)

	clonedModule:Destroy()

	return requireSuccess, requireMessage
end


local function RunProgram(program)
	if type(program) ~= "function" then
		return "Program is not a function!"
	end

	return xpcall(
		program,
		handleError,
		apiEnv
	)
end


local function LoadAndRunProgram(moduleScript)
	if moduleScript == nil then
        return "Arg [1] is nil! Must be a ModuleScript"
    elseif not (typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript")) then
        return "Arg [1] is not a ModuleScript!"
	end

	local loadSuccess, program = LoadProgram(moduleScript)
	if loadSuccess == false then
		return program
	end

	local runSuccess, runMessage = RunProgram(program)
	if runSuccess == false then
		return runMessage
	end

	return runMessage
end


local function RunSelectedPrograms()
	for i, selection in ipairs(Selection:Get()) do
		local result = LoadAndRunProgram(selection)
		if result then
			warn(("[%d] = %s"):format(
				i,
				result
			))
		end
	end

	ChangeHistoryService:SetWaypoint("RunProgram" .. tostring(tick()))
end

return {
	LoadProgram = LoadProgram,
	RunProgram = RunProgram,
	LoadAndRunProgram = LoadAndRunProgram,
	RunSelectedPrograms = RunSelectedPrograms
}