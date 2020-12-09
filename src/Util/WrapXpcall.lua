
local function WrapXpcall(func)
    local function handleError(message)
		return debug.traceback(tostring(message), 2)
    end

    return function(...)
        return xpcall(
			func,
			handleError,
			unpack({...})
		)
    end
end

return WrapXpcall