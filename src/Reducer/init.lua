--- Reducer
--

local function CurrentTrack(state, action)
    state = state or nil

    if action.type == "SetCurrentTrack" then
        return action.currentTrack
    end

    return state
end

local function CurrentTrackGroup(state, action)
    state = state or nil

    if action.type == "SetCurrentTrackGroup" then
        return action.currentTrackGroup
    end

    return state
end

local function StartPosition(state, action)
    state = state or 0

    if action.type == "SetStartPosition" then
        return action.position
    end

    return state
end

local function EndPosition(state, action)
    state = state or 1000

    if action.type == "SetEndPosition" then
        return action.position
    end

    return state
end

return function(state, action)
    state = state or {}

    return {
        currentTrack = CurrentTrack(state.currentTrack, action),
        currentTrackGroup = CurrentTrackGroup(state.currentTrackGroup, action),

        startPosition = StartPosition(state.startPosition, action),
        endPosition = EndPosition(state.endPosition, action),
    }
end