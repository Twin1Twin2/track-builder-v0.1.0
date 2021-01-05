# Segment (Module)

Describes how to build a piece of track.

## Contents

- [MeshData](./mesh_data.md)
- [Rail](./rail.md)
- [TrackObject](./track_object.md)
- [MidTrackObject](./mid_track_object.md)
- [Crossbeam](./crossbeam.md)
- [Rect](./rect.md)
- [RectRail](./rect_rail.md)
- [BoxRail](./box_rail.md)


## Module

```rs
Segment {
	Segment : Segment,
	IsType : function(object : any) -> (boolean, ?string),

	MeshData : MeshData,
	MeshDataBuilder : MeshDataBuilder,

	Rail : RailSegment,
	RailBuilder : RailSegmentBuilder,

	TrackObject : TrackObjectSegment,
	TrackObjectBuilder : TrackObjectSegmentBuilder,

	MidTrackObject : MidTrackObjectSegment,
	MidTrackObjectBuilder : MidTrackObjectSegmentBuilder,

	Crossbeam : CrossbeamSegment,
	CrossbeamBuilder : CrossbeamSegmentBuilder,

	Rect : RectSegment,
	RectBuilder : RectSegmentBuilder,

	RectRail : RectRailSegment,
	RectRailBuilder : RectRailSegmentBuilder,

	BoxRail : BoxRailSegment,
	BoxRailBuilder : BoxRailSegmentBuilder,

	Create : function(object : table | Instance) -> Segment,
	CreateFromData : function(data : table) -> Segment,
	CreateFromInstance : function(instance : Instance) -> Segment,
}
```

### Type Checking

The following functions are used for type checking.

#### IsType

```
Segment.IsType(object : any) -> boolean, ?string
```

Type checking function for a Segment. Returns true if a Segment

#### IsInstanceData

```
Segment.IsInstanceData(object : any) -> boolean, ?string
```

Type checking function for a Instance. Returns true if it has a `StringValue` called `SegmentType`

#### CheckInstance

```
Segment.CheckInstance(object : any) -> boolean, ?string
```

Type checking function for a Instance. Returns true if it can be converted into a Segment.


### Factory Pattern

The Segment module provides methods to use a factory pattern for the following functions.

Here's a list of the names used and their corresponding classes:

```lua
{
	Rail = RailSegment,
    TrackObject = TrackObjectSegment,
	MidTrackObject = MidTrackObjectSegment,
	Crossbeam = CrossbeamSegment,
	Rect = RectSegment,
	RectRail = RectRailSegment,
	BoxRail = BoxRailSegment,
}
```

#### Create

```
Segment.Create(object : any) -> boolean, ?string
```

Type checking function for a Segment. Returns true if a Segment

#### CreateFromData

```
Segment.CreateFromData(object : any) -> boolean, ?string
```

Factory pattern for creating a Segment.

Table must have a string called `SegmentType` as a value.

#### CreateFromInstance

```
Segment.CreateFromInstance(object : any) -> boolean, ?string
```

Factory pattern for creating a Segment. Creates a Segment from an Instance.

Instance must have a `StringValue` named `SegmentType` as one of it's children.


## Segment

Base Class for all Segments

```
Segment {
	Name : string
}
```

### Methods

#### Create

Produces a new segment instance based off of the two CFrame positions given

```lua
Segment:CreateAsync(startCFrame: CFrame, endCFrame: CFrame) -> Instance
```

#### CreateAsync

Like Create, but wraps this call in a Promise and returns it.

```lua
Segment:CreateAsync(startCFrame: CFrame, endCFrame: CFrame) -> Promise -> Instance
```
