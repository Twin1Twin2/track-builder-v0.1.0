--- Actions
--

local util = script.Parent.Util
local t = require(util.t)

return {
	SetCurrentTrack = function(currentTrackName)
		assert(t.tuple(t.optional(t.string))(currentTrackName))

		return {
			type = "SetCurrentTrack",
			currentTrack = currentTrackName,
		}
	end,

	-- temp
	SetCurrentTrackGroup = function(currentTrackGroupName)
		assert(t.tuple(t.optional(t.string))(currentTrackGroupName))

		return {
			type = "SetCurrentTrackGroup",
			currentTrackGroup = currentTrackGroupName,
		}
	end,

	SetStartPosition = function(position)
		assert(t.tuple(t.number)(position))

		return {
			type = "SetStartPosition",
			position = position,
		}
	end,

	SetEndPosition = function(position)
		assert(t.tuple(t.number)(position))

		return {
			type = "SetEndPosition",
			position = position,
		}
	end,
}