# Rect Segment

Creates a Rectangle made out of 2 triangle/wedges and positioned at a given point in the track.

## RectSegment

**Extends [Segment](./index.md#segment)**

```rs
RectSegment : Segment {
	Wedge : WedgePart,

	P0 : Vector3,
	P1 : Vector3,
	P2 : Vector3,
	P3 : Vector3,
}
```

### Properties

**Wedge**

The WedgePart used to make the rectangle. This will be cloned each time a new segment is created.

**P0**

Offset 1

**P1**

Offset 2

**P2**

Offset 3

**P3**

Offset 4


### Constructors

#### fromData

```lua
RectSegment.fromData(data: table) -> RectSegment
```

##### data

```rs
{
	Name : string,

	Wedge : WedgePart,

	P0 : Vector3,
	P1 : Vector3,
	P2 : Vector3,
	P3 : Vector3,
}
```

#### fromInstance

```lua
RectSegment.fromInstance(instance: Instance) -> RectSegment
```

##### instance Children

```rs
{
	Wedge : ?WedgePart,

	P0 : Vector3OffsetInstance,
	P1 : Vector3OffsetInstance,
	P2 : Vector3OffsetInstance,
	P3 : Vector3OffsetInstance,
}
```

## RectSegmentBuilder

### Constructors

#### new

```rs
RectSegmentBuilder.new() -> RectSegmentBuilder
```

### Methods

#### WithWedge

```rs
RectSegmentBuilder:WithWedge(basePart : BasePart) -> self
```

#### WithP0

```rs
RectSegmentBuilder:WithP0(offset : Vector3) -> self
```

#### WithP1

```rs
RectSegmentBuilder:WithP1(offset : Vector3) -> self
```

#### WithP2

```rs
RectSegmentBuilder:WithP2(offset : Vector3) -> self
```

#### WithP3

```rs
RectSegmentBuilder:WithP3(offset : Vector3) -> self
```