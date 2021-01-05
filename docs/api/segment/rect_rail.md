# RectRail Segment

Creates a Rail using Triangles based on 4 points. Two points are offsets from the start position and two are offsets from the end position.

## RectRailSegment

**Extends [Segment](./index.md#segment)**

```rs
RectRailSegment : Segment {
	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

### Properties

**Wedge**

**StartOffset1**

Offset relative to the start position

**StartOffset2**

Offset relative to the start position

**EndOffset1**

Offset relative to the end position

**EndOffset2**

Offset relative to the end position

### Constructors

#### fromData

```lua
RectRailSegment.fromData(data: table) -> RectRailSegment
```

##### data

```rs
{
	Name : string,

	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

#### fromInstance

```lua
RectRailSegment.fromInstance(instance: Instance) -> RectRailSegment
```

##### instance Children

```rs
{
	Wedge : ?WedgePart,

	StartOffset1 : Vector3OffsetInstance,
	StartOffset2 : Vector3OffsetInstance,
	EndOffset1 : Vector3OffsetInstance,
	EndOffset2 : Vector3OffsetInstance,
}
```

## RectRailSegmentBuilder

```rs
{
	Name : string,

	Wedge : WedgePart,

	StartOffset1 : Vector3,
	StartOffset2 : Vector3,
	EndOffset1 : Vector3,
	EndOffset2 : Vector3,
}
```

### Constructors

#### new

```rs
RectRailSegmentBuilder.new() -> RectRailSegmentBuilder
```

### Methods

#### WithWedge

```rs
RectRailSegmentBuilder:WithWedge(wedge : WedgePart) -> self
```

#### WithOffset

```rs
RectRailSegmentBuilder:WithOffset(offset : Vector3) -> self
```