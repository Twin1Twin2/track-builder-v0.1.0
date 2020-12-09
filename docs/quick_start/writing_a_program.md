# Writing A Program

## Why Program?

For programmers or anyone with a good handle of Roblox Lua, this may be faster option than setting it up manually.
Additionally, the GUI is still a work in progress, so you still have access to all of the API.

## What is a Program?

ModuleScript that returns a function. This function takes the API as it's argument

> The API is passed in as an argument instead of injected into the script environment as Roblox would yell at you for errors.

## Track Setup

As there are a ton a points, we will set this up via Instance.

### Setup Points

TheEpicTwin's Edit of Spacek's Coaster Plugin

OrderedPoints

## Program

Different classes

- CFrameTrack
- Segment
- Section
- TrackGroup
- PhysicsRails

CFrameTrack a 3D line that defines the position of the track

Segment builds a Part or Model from on a start and an end CFrame

Section builds segments for a track from a start and end position

TrackGroup builds multiple sections for a track from a start and end position

Segments
- Rail
- TrackObject
- MidTrackObject
- Crossbeam
- Rect
- RectRail
- BoxRail



## Left Rail

SegmentBuilder:Build()


## Right Rail


## Tie


## Crossbeam


## Build What You Have So Far

TrackGroup

