--- Returns Get/Convert and Check functions for the given Enum
-- EnumItems can also be Strings, Integer
-- See: https://developer.roblox.com/en-us/articles/Enumeration

local t = require(script.Parent.t)

local IsValidEnumValue = t.union(
	t.EnumItem,
	t.integer,
	t.string
)

local function EnumType(enum)
	assert(t.Enum(enum))

	local enumItems = {}
	local enumIntegers = {}
	local enumNames = {}

	for _, enumItem in ipairs(enum:GetEnumItems()) do
		enumItems[enumItem] = enumItem
		enumIntegers[enumItem.Value] = enumItem
		enumNames[enumItem.Name] = enumItem
	end

	local function Get(value)
		if t.EnumItem(value) then
			return enumItems[value]
		elseif t.integer(value) then
			return enumIntegers[value]
		elseif t.string(value) then
			return enumNames[value]
		end

		return nil
	end

	local function Check(value)
		local enumValueSuccess, enumValueMessage
			= IsValidEnumValue(value)

		if enumValueSuccess == false then
			return false, enumValueMessage
		end

		local enumItem = Get(value)
		if enumItem then
			return true, enumItem
		end

		local message = "invalid object"

		if t.EnumItem(value) then
			message = "invalid EnumItem: " .. value.Name
		elseif t.integer(value) then
			message = "invalid enum value: " .. tostring(value)
		elseif t.string(value) then
			message = "invalid string: " .. value
		end

		return false, message
	end

	local function CheckAndGet(value)
		local checkSuccess, checkMessage
			= Check(value)

		if checkSuccess == false then
			return false, checkMessage
		end

		return checkMessage
	end

	return {
		Get = Get,
		Check = Check,
		CheckAndGet = CheckAndGet,
	}
end


-- caching
local enumTypes = {}

return function(enum)
	assert(t.Enum(enum))

	local enumType = enumTypes[enum]

	if enumType then
		return enumType
	end

	enumType = EnumType(enum)
	enumTypes[enum] = enumType

	return enumType
end