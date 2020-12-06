# Segment

Describes how to build a piece of track.

## Module

```rs
Segment {
	Segment : Segment,
	IsType : function,

	MeshData : MeshData,

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

	Box : BoxSegment,
	BoxBuilder : BoxSegmentBuilder,

	Create : function,
	CreateFromData : function,
	CreateFromInstance : function,
}
```

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

## RailSegment

Creates a BasePart that is positioned parallel to the Track.
Similar to Rails in NewSmooth plugins

```rs
RailSegment : Segment {
	BasePart : BasePart,

	Offset : Vector3,
	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : MeshData,
}
```

### Constructors

#### fromData

```lua
RailSegment.fromData(data: table) -> RailSegment
```

##### data

```rs
{
	Name : string,

	BasePart : BasePart,

	Offset : Vector3,
	Size : Vector3,
	Rotation : Vector3,
	Horizontal : boolean

	MeshData : ?MeshData,
}
```

#### fromInstance

```lua
RailSegment.fromInstance(instance: Instance) -> RailSegment
```

##### instance Children

```rs
{
	BasePart : BasePart,

	Offset : Vector3Value,
	Size : Vector3Value,
	Rotation : Vector3Value,
	Horizontal : BoolValue,

	MeshData : Instance, // see MeshData.fromInstance
}
```

## MeshData

Mesh data struct for the NewSmooth Algorithm.

Used by:

- RailSegment
- CrossbeamSegment

### Constructors

#### fromData

```lua
MeshData.fromData(data: table) -> MeshData
```

##### data

```rs
{
	Mesh : string,
	MeshType : Enum.MeshType,

	Offset : Vector3,
	Scale : Vector3,
}
```

#### fromInstance

```lua
MeshData.fromInstance(instance: Instance) -> MeshData
```

##### instance Children

```rs
{
	Mesh : StringValue,
	MeshType : StringValue,

	Offset : Vector3Value,
	Scale : Vector3Value,
}
```