
local t = require(script.Parent.t)

-- loop through the metatable indexes to get the class
-- return function(class)
-- 	return function(value)
-- 		local tableSuccess, tableErrMsg = t.table(value)
-- 		if not tableSuccess then
-- 			return false, tableErrMsg or "" -- pass error message for value not being a table
-- 		end

-- 		local isClass
-- 		local function IsClass()
-- 			local mt = getmetatable(value)

-- 			if mt == nil then
-- 				return false
-- 			end

-- 			if not mt or mt.__index ~= class then
-- 			end
-- 		end

-- 		if isClass == false then
-- 			return false, "Not a " .. class.ClassName -- custom error message
-- 		end

-- 		return true -- all checks passed
-- 	end
-- end

-- hack
return function(class)
	local IDENTIFIER = newproxy()	-- kinda a hack for now
	class[IDENTIFIER] = true

	return function(value)
		local tableSuccess, tableErrMsg = t.table(value)
		if not tableSuccess then
			return false, tableErrMsg or "" -- pass error message for value not being a table
		end

		return class[IDENTIFIER] ~= nil
	end
end