# Writing A Program

!!! warning
	This is still a work in progress. The API is still changing and thus this code may not work properly.

## Why Program?

For programmers or anyone with a good handle of Roblox Lua, it can be faster than setting it up manually.
Additionally, the GUI is still a work in progress, so you still have access to all of the API.

## What is a Program?

ModuleScript that returns a function. This function takes the API as it's argument

> The API is passed in as an argument instead of injected into the script environment as Roblox would yell at you for errors.

## Track Setup

As there are a ton a points, we will set this up via Instance.

### Setup Points

Requires that the points be named in order from start to end.

TheEpicTwin's Edit of Spacek's Coaster Plugin

OrderedPoints

```lua
local trackPoints = workspace:FindFirstChild("Track")

local cframeTrack = PointToPoint2Builder.new()
	:WithName("MyTrack")
	:WithPoints(trackPoints)
	:WithIsCircuited(true)
	:WithHashInterval(10)
	:Finish()
```

## Program API

- CFrameTrack
- Segment
- Section
- TrackGroup
- PhysicsRails

CFrameTrack a 3D line that defines the position of the track.

Segment builds a Part or Model from on a start and an end CFrame.

Section builds segments from a start and end position for a given track.

TrackGroup builds multiple sections for a track from a start and end position.

Segments:

- Rail
- TrackObject
- MidTrackObject
- Crossbeam
- Rect
- RectRail
- BoxRail

For now, we will only be using 3. Check the examples if you would like to see how the others are used.

## Left Rail

```lua
local RailSegmentBuilder = Segment.RailBuilder

local leftRailSection = SectionBuilder.new()
	:WithName("LeftRail")
	:WithSegment(RailSegmentBuilder.new()
		:WithBasePart(RAIL_PART)
		:WithOffset(Vector3.new(-3, 0, 0))
		:WithHorizontal(true)
		:WithMeshData(MeshDataBuilder.new()
			:WithMesh("CylinderMesh")
			:WithOffset(Vector3.new(0, 0, 0))
			:WithScale(Vector3.new(1, 1, 0.2))
			:Finish()
		)
		:Finish()
	)
	:WithSegmentLength(5)
	:WithSectionStart(0)
	:WithOptimize(true)
	:WithBuildEnd(false)
	:Finish()
```

## Right Rail
```lua
local rightRailSection = SectionBuilder.new()
	:WithName("RightRail")
	:WithSegment(RailSegmentBuilder.new()
		:WithBasePart(RAIL_PART)
		:WithOffset(Vector3.new(3, 0, 0))
		:WithHorizontal(true)
		:WithMeshData(MeshDataBuilder.new()
			:WithMesh("CylinderMesh")
			:WithOffset(Vector3.new(0, 0, 0))
			:WithScale(Vector3.new(1, 1, 0.2))
			:Finish()
		)
		:Finish()
	)
	:WithSegmentLength(5)
	:WithSectionStart(0)
	:WithOptimize(true)
	:WithBuildEnd(false)
	:Finish()
```

## Tie
```lua
local tieSection = SectionBuilder.new()
	:WithName("Tie")
	:WithSegment(TrackObjectSegmentBuilder.new()
		:WithTrackObject(TIE_PART)
		:WithOffset(CFrame.new(0, 0, 0))
		:Finish()
	)
	:WithSegmentLength(5)
	:WithSectionStart(0)
	:WithOptimize(true)
	:WithBuildEnd(false)
	:Finish()
```

## Crossbeam
```lua
local crossbeamSection = SectionBuilder.new()
	:WithName("Crossbeam")
	:WithSegment(CrossbeamSegmentBuilder.new()
		:WithBasePart(CROSSBEAM_PART)
		:WithStartOffset(Vector3.new(3, 0, 0))
		:WithEndOffset(Vector3.new(-3, 0, 0))
		:Finish()
	)
	:WithSegmentLength(5)
	:WithSectionStart(0)
	:WithOptimize(true)
	:WithBuildEnd(false)
	:Finish()
```

## Build

```lua
local trackGroup = TrackGroupBuilder.new()
	:WithName("MyTrack")
	:WithSection(leftRailSection)
	:WithSection(rightRailSection)
	:WithSection(tieSection)
	:WithSection(crossbeamSection)
	:Finish()
```

```lua
local trackModel = trackGroup:Create(
	cframeTrack,
	0,
	cframeTrack.Length
)

trackModel.Parent = workspace
```


## Full Code

```lua linenums="0"
return function(api)
	local TrackGroup = api.TrackGroup
	local Section = api.Section

	local CFrameTrack = api.CFrameTrack
	local PointToPoint2Builder = CFrameTrack.PointToPoint2Builder

	local Segment = api.Segment
	local RailSegmentBuilder = Segment.RailBuilder
	local TrackObjectSegmentBuilder = Segment.TrackObjectBuilder
	local CrossbeamBuilder = Segment.CrossbeamBuilder

	local trackPoints = workspace:FindFirstChild("Track")

	local cframeTrack = PointToPoint2Builder.new()
		:WithName("MyTrack")
		:WithPoints(trackPoints)
		:WithIsCircuited(true)
		:WithHashInterval(10)
		:Finish()

	local leftRailSection = SectionBuilder.new()
		:WithName("LeftRail")
		:WithSegment(RailSegment.new()
			:WithBasePart(RAIL_PART)
			:WithOffset(Vector3.new(-3, 0, 0))
			:WithHorizontal(true)
			:WithMeshData(MeshDataBuilder.new()
				:WithMesh("CylinderMesh")
				:WithOffset(Vector3.new(0, 0, 0))
				:WithScale(Vector3.new(1, 1, 0.2))
				:Finish()
			)
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()

	local rightRailSection = SectionBuilder.new()
		:WithName("RightRail")
		:WithSegment(RailSegmentBuilder.new()
			:WithBasePart(RAIL_PART)
			:WithOffset(Vector3.new(3, 0, 0))
			:WithHorizontal(true)
			:WithMeshData(MeshDataBuilder.new()
				:WithMesh("CylinderMesh")
				:WithOffset(Vector3.new(0, 0, 0))
				:WithScale(Vector3.new(1, 1, 0.2))
				:Finish()
			)
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()

	local tieSection = SectionBuilder.new()
		:WithName("Tie")
		:WithSegment(TrackObjectSegmentBuilder.new()
			:WithTrackObject(TIE_PART)
			:WithOffset(CFrame.new(0, 0, 0))
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()

	local crossbeamSection = SectionBuilder.new()
		:WithName("Crossbeam")
		:WithSegment(CrossbeamSegmentBuilder.new()
			:WithBasePart(CROSSBEAM_PART)
			:WithStartOffset(Vector3.new(3, 0, 0))
			:WithEndOffset(Vector3.new(-3, 0, 0))
			:Finish()
		)
		:WithSegmentLength(5)
		:WithSectionStart(0)
		:WithOptimize(true)
		:WithBuildEnd(false)
		:Finish()

	local trackGroup = TrackGroupBuilder.new()
		:WithName("MyTrack")
		:WithSection(leftRailSection)
		:WithSection(rightRailSection)
		:WithSection(tieSection)
		:WithSection(crossbeamSection)
		:Finish()

	local model = Instance.new("Model")

	local trackModel = trackGroup:Create(
		cframeTrack,
		0,
		cframeTrack.Length
	)
	trackModel.Parent = model

	local chainLiftModel = chainLiftSection:Create(
		cframeTrack,
		100,
		200
	)
	chainLiftModel.Parent = model

	local brakesModel = brakesSection:Create(
		cframeTrack,
		400,
		500
	)
	brakesModel.Parent = model

	model.Parent = workspace
end
```