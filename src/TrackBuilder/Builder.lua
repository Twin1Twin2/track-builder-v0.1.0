--- Builder

local util = script.Parent.Util
local t = require(util.t)

local Builder = {
	ClassName = "Builder";
}

Builder.__index = Builder


function Builder.new()
	local self = setmetatable({}, Builder)


	return self
end


function Builder:Destroy()
	setmetatable(self, nil)
end


function Builder:Build()
	error("Unimplemented! " .. self.ClassName)
end


function Builder:Finish()
	local object = self:Build()

	self:Destroy()

	return object
end

local checkProperties = t.array(t.string)

Builder.Check = function(checkTable)
	assert(checkProperties(checkTable))

	return function(builder)
		local notSetList = {}
		for _, name in ipairs(checkTable) do
			if builder[name] == nil then
				table.insert(notSetList, name)
			end
		end

		if #notSetList > 0 then
			local errorMessage = "not setup!"
			for _, name in ipairs(notSetList) do
				errorMessage = errorMessage .. "\n    - " .. name
			end

			return false,errorMessage
		end

		return true
	end
end


return Builder