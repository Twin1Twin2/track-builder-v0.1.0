
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

local function RunProgram(moduleScript)
    if moduleScript == nil then
        return "Arg [1] is nil! Must be a ModuleScript"
    elseif not (typeof(moduleScript) == "Instance" and moduleScript:IsA("ModuleScript")) then
        return "Arg [1] is not a ModuleScript!"
    end

    local function handleError(message)
		return debug.traceback(tostring(message), 2)
    end

    local program

	local clonedModule = moduleScript:Clone()   -- to allow reloading
	clonedModule.Parent = moduleScript.Parent   -- keep the same workspace env

	local requireSuccess, requireMessage = xpcall(
		require,
		handleError,
		clonedModule
	)

	clonedModule:Destroy()

	if requireSuccess == false then
		return requireMessage
	end

	program = requireMessage
	if type(program) ~= "function" then
		return "Program did not return a function!"
	end

	local runSuccess, runMessage = xpcall(
		program,
		handleError,
		apiEnv
	)
	if runSuccess == false then
		return runMessage
	end
end

local function RunPrograms()
	for i, selection in ipairs(Selection:Get()) do
		local result = RunProgram(selection)
		if result then
			warn(("[%d] = %s"):format(
				i,
				result
			))
		end
	end

	ChangeHistoryService:SetWaypoint("RunProgram" .. tostring(tick()))
end

return RunPrograms